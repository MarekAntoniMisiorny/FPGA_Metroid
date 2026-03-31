import tkinter as tk
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

SIZE_FILE = os.path.join(BASE_DIR, "size.txt")
DATA_FILE = os.path.join(BASE_DIR, "dane.txt")
KEYS_FILE = os.path.join(BASE_DIR, "keys.txt")
TIME_FILE = os.path.join(BASE_DIR, "sim_time.txt")

COLORS = {
    0: "#000000",  # black
    1: "#0000ff",  # blue
    2: "#00ff00",  # green
    3: "#00ffff",  # cyan
    4: "#ff0000",  # red
    5: "#ff00ff",  # magenta
    6: "#ffff00",  # yellow
    7: "#ffffff",  # white
}

left_pressed = 0
right_pressed = 0
up_pressed = 0
down_pressed = 0

# debugowe offsety obrazu
X_OFFSET = -3
Y_OFFSET = 0


def save_keys():
    with open(KEYS_FILE, "w") as f:
        f.write(f"{left_pressed} {right_pressed} {up_pressed} {down_pressed}\n")


def on_key_press(event):
    global left_pressed, right_pressed, up_pressed, down_pressed

    if event.keysym == "Left":
        left_pressed = 1
    elif event.keysym == "Right":
        right_pressed = 1
    elif event.keysym == "Up":
        up_pressed = 1
    elif event.keysym == "Down":
        down_pressed = 1

    save_keys()


def on_key_release(event):
    global left_pressed, right_pressed, up_pressed, down_pressed

    if event.keysym == "Left":
        left_pressed = 0
    elif event.keysym == "Right":
        right_pressed = 0
    elif event.keysym == "Up":
        up_pressed = 0
    elif event.keysym == "Down":
        down_pressed = 0

    save_keys()


def offset_left(event=None):
    global X_OFFSET
    X_OFFSET -= 1
    print("X_OFFSET =", X_OFFSET)


def offset_right(event=None):
    global X_OFFSET
    X_OFFSET += 1
    print("X_OFFSET =", X_OFFSET)


def offset_up(event=None):
    global Y_OFFSET
    Y_OFFSET -= 1
    print("Y_OFFSET =", Y_OFFSET)


def offset_down(event=None):
    global Y_OFFSET
    Y_OFFSET += 1
    print("Y_OFFSET =", Y_OFFSET)


def load_size():
    with open(SIZE_FILE, "r") as f:
        lines = [line.strip() for line in f.readlines()]

    w = int(lines[0])
    h = int(lines[1])
    pixel = int(lines[2])
    return w, h, pixel


def load_data(w, h):
    try:
        with open(DATA_FILE, "r") as f:
            lines = [line.rstrip("\n") for line in f.readlines()]
    except FileNotFoundError:
        return None

    if len(lines) < h:
        return None

    data = []
    for y in range(h):
        row = lines[y].strip()

        if len(row) < w:
            return None

        for x in range(w):
            ch = row[x]
            if ch.isdigit():
                val = int(ch)
                if 0 <= val <= 7:
                    data.append(val)
                else:
                    data.append(0)
            else:
                data.append(0)

    return data


def load_sim_time():
    try:
        with open(TIME_FILE, "r") as f:
            txt = f.read().strip()
    except FileNotFoundError:
        return "brak sim_time.txt"

    if txt == "":
        return "czas symulacji: ?"

    return f"czas symulacji: {txt}"


class Viewer:
    def __init__(self, root):
        self.root = root
        self.root.title("FPGA Video Viewer")

        self.w, self.h, self.pixel = load_size()
        self.last_data_mtime = None
        self.last_time_mtime = None

        self.info_label = tk.Label(
            root,
            text="czas symulacji: ?",
            anchor="w",
            font=("Consolas", 11)
        )
        self.info_label.pack(fill="x")

        self.canvas = tk.Canvas(
            root,
            width=self.w * self.pixel,
            height=self.h * self.pixel,
            bg="black",
            highlightthickness=0
        )
        self.canvas.pack()

        self.rects = []
        for y in range(self.h):
            for x in range(self.w):
                x0 = x * self.pixel
                y0 = y * self.pixel
                x1 = x0 + self.pixel
                y1 = y0 + self.pixel
                rect = self.canvas.create_rectangle(
                    x0, y0, x1, y1,
                    outline="",
                    fill="#000000"
                )
                self.rects.append(rect)

        self.root.bind_all("<KeyPress-Left>", on_key_press)
        self.root.bind_all("<KeyRelease-Left>", on_key_release)
        self.root.bind_all("<KeyPress-Right>", on_key_press)
        self.root.bind_all("<KeyRelease-Right>", on_key_release)
        self.root.bind_all("<KeyPress-Up>", on_key_press)
        self.root.bind_all("<KeyRelease-Up>", on_key_release)
        self.root.bind_all("<KeyPress-Down>", on_key_press)
        self.root.bind_all("<KeyRelease-Down>", on_key_release)

        # sterowanie offsetem debugowym
        self.root.bind_all("a", offset_left)
        self.root.bind_all("d", offset_right)
        self.root.bind_all("w", offset_up)
        self.root.bind_all("s", offset_down)

        self.canvas.bind("<Button-1>", self.set_focus)
        self.root.after(200, self.force_focus)

        save_keys()
        self.update_frame()

    def set_focus(self, event=None):
        self.root.focus_force()
        self.canvas.focus_set()

    def force_focus(self):
        try:
            self.root.lift()
            self.root.focus_force()
            self.canvas.focus_set()
        except Exception:
            pass

    def update_frame(self):
        # aktualizacja czasu symulacji
        try:
            time_mtime = os.path.getmtime(TIME_FILE)
        except FileNotFoundError:
            time_mtime = None

        if time_mtime is not None and self.last_time_mtime != time_mtime:
            self.last_time_mtime = time_mtime
            sim_time_txt = load_sim_time()
            self.info_label.config(
                text=f"{sim_time_txt}    X_OFFSET={X_OFFSET}    Y_OFFSET={Y_OFFSET}"
            )
        else:
            self.info_label.config(
                text=f"czas symulacji: ?    X_OFFSET={X_OFFSET}    Y_OFFSET={Y_OFFSET}"
            )

        # aktualizacja obrazu
        try:
            data_mtime = os.path.getmtime(DATA_FILE)
        except FileNotFoundError:
            self.root.after(100, self.update_frame)
            return

        if self.last_data_mtime != data_mtime:
            self.last_data_mtime = data_mtime
            data = load_data(self.w, self.h)

            if data is not None:
                for y in range(self.h):
                    for x in range(self.w):
                        src_x = (x + X_OFFSET) % self.w
                        src_y = (y + Y_OFFSET) % self.h

                        val = data[src_y * self.w + src_x]
                        color = COLORS.get(val, "#000000")
                        self.canvas.itemconfig(self.rects[y * self.w + x], fill=color)

        self.root.after(100, self.update_frame)


if __name__ == "__main__":
    root = tk.Tk()
    app = Viewer(root)
    root.mainloop()