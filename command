import random
import tkinter as tk

root = tk.Tk()
root.title("2048")
root.geometry("300x300")
place = [
    [-1, -1, -1, -1, -1, -1],
    [-1, 0, 0, 0, 0, -1],
    [-1, 0, 0, 0, 0, -1],
    [-1, 0, 0, 0, 0, -1],
    [-1, 0, 0, 0, 0, -1],
    [-1, -1, -1, -1, -1, -1]
]
for _ in range(2):
    while True:
        i, j = random.randint(1, 4), random.randint(1, 4)
        if place[i][j] == 0:
            place[i][j] = 2
            break
frame = tk.Frame(root)
frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)


def update_gui():
    for widget in frame.winfo_children():
        widget.destroy()
    for i in range(6):
        for j in range(6):
            value = place[i][j]
            if value == -1:
                label = tk.Label(frame, text="", bg="gray", width=4, height=2)
            elif value == 0:
                label = tk.Label(frame, text="", bg="#CDC1B4", width=4, height=2)
            else:
                label = tk.Label(frame, text=str(value), bg="#EEE4DA", width=4, height=2, font=("Arial", 14, "bold"))
            label.grid(row=i, column=j, padx=2, pady=2)


def handle_key(event):
    key = event.keysym.lower()
    moved = False
    if key in 'w':
        for _ in range(3):
            for i in range(2, 5):
                for j in range(1, 5):
                    if place[i - 1][j] == 0 and place[i][j] > 0:
                        place[i - 1][j] = place[i][j]
                        place[i][j] = 0
                        moved = True
                    elif place[i - 1][j] == place[i][j] and place[i][j] > 0:
                        place[i - 1][j] *= 2
                        place[i][j] = 0
                        moved = True
    elif key in 's':
        for _ in range(3):
            for i in range(4, 1, -1):
                for j in range(1, 5):
                    if place[i][j] == 0 and place[i - 1][j] > 0:
                        place[i][j] = place[i - 1][j]
                        place[i - 1][j] = 0
                        moved = True
                    elif place[i][j] == place[i - 1][j] and place[i - 1][j] > 0:
                        place[i][j] *= 2
                        place[i - 1][j] = 0
                        moved = True
    elif key in 'a':
        for _ in range(3):
            for j in range(2, 5):
                for i in range(1, 5):
                    if place[i][j - 1] == 0 and place[i][j] > 0:
                        place[i][j - 1] = place[i][j]
                        place[i][j] = 0
                        moved = True
                    elif place[i][j - 1] == place[i][j] and place[i][j] > 0:
                        place[i][j - 1] *= 2
                        place[i][j] = 0
                        moved = True
    elif key in 'd':
        for _ in range(3):
            for j in range(4, 1, -1):
                for i in range(1, 5):
                    if place[i][j] == 0 and place[i][j - 1] > 0:
                        place[i][j] = place[i][j - 1]
                        place[i][j - 1] = 0
                        moved = True
                    elif place[i][j] == place[i][j - 1] and place[i][j - 1] > 0:
                        place[i][j] *= 2
                        place[i][j - 1] = 0
                        moved = True
    if moved:
        empty_cells = [(i, j) for i in range(1, 5) for j in range(1, 5) if place[i][j] == 0]
        if empty_cells:
            i, j = random.choice(empty_cells)
            place[i][j] = 2 if random.random() < 0.9 else 4
    update_gui()
    a = -1
    if any(2048 in row for row in place):
        show_message("胜利")
    elif not any(0 in row for row in place[1:5]):
        a = 1
        for i in range(1, 5):
            for j in range(1, 4):
                if place[i][j] == place[i][j + 1] or \
                        place[j][i] == place[j + 1][i]:
                    a = 0
                    return
        if a == 1:
            show_message("失败")


def show_message(msg):
    popup = tk.Toplevel(root)
    popup.title("结束")
    tk.Label(popup, text=msg, font=("Arial", 14)).pack(pady=10)
    tk.Button(popup, text="重新开始", command=lambda: [reset_game(), popup.destroy()]).pack()
    tk.Button(popup, text="退出", command=root.quit).pack()
    root.bind('q', lambda e: [reset_game(), popup.destroy()])


def reset_game():
    global place
    place = [
        [-1, -1, -1, -1, -1, -1],
        [-1, 0, 0, 0, 0, -1],
        [-1, 0, 0, 0, 0, -1],
        [-1, 0, 0, 0, 0, -1],
        [-1, 0, 0, 0, 0, -1],
        [-1, -1, -1, -1, -1, -1]
    ]
    for _ in range(2):
        while True:
            i, j = random.randint(1, 4), random.randint(1, 4)
            if place[i][j] == 0:
                place[i][j] = 2
                break
    update_gui()


root.bind('<Key>', handle_key)
update_gui()
root.mainloop()
