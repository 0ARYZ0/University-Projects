import pygame
from pygame.locals import *
from OpenGL.GL import *
import math
import time
import random
######################### Ahmadreza Yazdani (9932095) #############################################

CELL_SIZE = 30
pygame.init()
display = (CELL_SIZE * 28, CELL_SIZE * 24)
pygame.display.set_mode(display, DOUBLEBUF | OPENGL)
#glOrtho(0, 800, 0, 600, -1, 1)
glOrtho(0, display[0], 0, display[1], -1, 1)  #orthographic projection


ROWS = 24
COLS = 28
MAP = [
    "############################",
    "#............##............#",
    "#.####.#####.##.#####.####.#",
    "#F####.#####.##.#####.####F#",
    "#.####.#####.##.#####.####.#",
    "#..........................#",
    "#.####.##.########.##.####.#",
    "#.####.##.########.##.####.#",
    "#......##....##....##......#",
    "######.##### ## #####.######",
    "######.##### ## #####.######",
    "######.##          ##.######",
    "######.## ###--### ##.######",
    "#............##............#",
    "#.####.#####.##.#####.####.#",
    "#.####.#####.##.#####.####.#",
    "#F..##....... ........##..F#",
    "###.##.##.########.##.##.###",
    "###.##.##.########.##.##.###",
    "#......##....##....##......#",
    "#.##########.##.##########.#",
    "#.##########.##.##########.#",
    "#..........................#",
    "############################",
    "############################",
]

#  draw a rectangle (used for walls and paths)
def rectangle_draw(x, y, width, height, color):
    glBegin(GL_QUADS)
    glColor3fv(color)
    glVertex2f(x, y)
    glVertex2f(x + width, y)
    glVertex2f(x + width, y + height)
    glVertex2f(x, y + height)
    glEnd()

#  check for collisions with walls considering Pac-Man's size
def check_collision(x, y, size):
    row_top = int((y + size / 2) // CELL_SIZE)
    row_bottom = int((y - size / 2) // CELL_SIZE)
    col_left = int((x - size / 2) // CELL_SIZE)
    col_right = int((x + size / 2) // CELL_SIZE)

    if MAP[row_top][col_left] == '#' or MAP[row_top][col_right] == '#' or \
       MAP[row_bottom][col_left] == '#' or MAP[row_bottom][col_right] == '#':
        return True
    return False

#  check for collisions with dots
def check_score_collision(x, y, size):
    row = int(y // CELL_SIZE)
    col = int(x // CELL_SIZE)
    if MAP[row][col] == '.':
        MAP[row] = MAP[row][:col] + ' ' + MAP[row][col+1:]
        return 1, False
    elif MAP[row][col] == 'F':
        MAP[row] = MAP[row][:col] + ' ' + MAP[row][col+1:]
        return 10, True
    return 0, False

# Pac-Man class
class PacMan:
    def __init__(self, x, y, size):
        self.x = x
        self.y = y
        self.size = size
        self.color = (1, 1, 0)  # Yellow color
        self.direction = (0, 0)
        self.desired_direction = (0, 0)
        self.eaten_fruit_time = None
        self.speed = 1.5  #  to set the speed of Pac-Man
        self.mouth_angle = 0.2  # Mouth Size
        self.mouth_opening = True
        
    def draw(self):
        num_segments = 100
        x = self.size
        y = 0

        start_angle = self.mouth_angle * math.pi
        end_angle = (2 - self.mouth_angle) * math.pi


        direction_angle = 0
        # Calculate mouth angle based on direction
        if self.direction == ( 0, CELL_SIZE / 8 ):
            direction_angle = math.pi / 2  

        elif self.direction == (0, (-1 * CELL_SIZE) / 8 ):  
            direction_angle = -1 * math.pi / 2

        elif self.direction == ( (-1 * CELL_SIZE) / 8 , 0):  
            direction_angle = math.pi 

        elif self.direction == ( CELL_SIZE / 8 , 0):  
            direction_angle = 0

        glBegin(GL_TRIANGLE_FAN)
        glColor3fv(self.color)
        glVertex2f(self.x, self.y)
        
        for i in range(num_segments + 1):
            angle = start_angle + (i / num_segments) * (end_angle - start_angle) + direction_angle
            x = self.size * math.cos(angle)
            y = self.size * math.sin(angle)
            glVertex2f(self.x + x, self.y + y)
        glEnd()

    def update_mouth(self):
        if self.mouth_opening:
            self.mouth_angle += 0.03
            if self.mouth_angle >= 0.3:
                self.mouth_opening = False
        else:
            self.mouth_angle -= 0.03
            if self.mouth_angle <= 0.02:
                self.mouth_opening = True



    def move(self):
        if not check_collision(self.x + self.desired_direction[0] * self.speed, self.y + self.desired_direction[1] * self.speed, self.size):
            self.direction = self.desired_direction

        new_x = self.x + self.direction[0] * self.speed
        new_y = self.y + self.direction[1] * self.speed
        if not check_collision(new_x, self.y, self.size):
            self.x = new_x
        if not check_collision(self.x, new_y, self.size):
            self.y = new_y

    def change_direction(self, new_direction):
        self.desired_direction = new_direction

    def reset_color(self):
        if self.eaten_fruit_time and time.time() - self.eaten_fruit_time > 5:
            self.color = (1, 1, 0)  # Back to yellow color

# Ghost class
class Ghost:
    def __init__(self, x, y, size, color):
        self.x = x
        self.y = y
        self.size = size
        self.color = color
        self.original_color = color
        self.direction = (1, 0)
        self.frightened = False
        self.frightened_start_time = None

    def draw(self):
        # Draw the square body
        glBegin(GL_QUADS)
        glColor3fv(self.color)
        glVertex2f(self.x - self.size / 2, self.y - self.size / 2)
        glVertex2f(self.x + self.size / 2, self.y - self.size / 2)
        glVertex2f(self.x + self.size / 2, self.y + self.size / 2)
        glVertex2f(self.x - self.size / 2, self.y + self.size / 2)
        glEnd()
        
        # Draw the half-circle top
        num_segments = 50
        theta = 2 * 3.1415926 / num_segments
        c = math.cos(theta)
        s = math.sin(theta)
        x = self.size / 2
        y = 0

        glBegin(GL_TRIANGLE_FAN)
        glColor3fv(self.color)
        glVertex2f(self.x, self.y + self.size / 2)
        for i in range(num_segments // 2 + 1):
            glVertex2f(self.x + x, self.y + self.size / 2 + y)
            t = x
            x = c * x - s * y
            y = s * t + c * y
        glEnd()
        
        # Draw the bottom triangles (feet)
        triangle_height = self.size / 4
        triangle_width = self.size / 4
        for i in range(3):
            glBegin(GL_TRIANGLES)
            glColor3fv(self.color)
            glVertex2f(self.x - self.size / 2 + i * triangle_width, self.y - self.size / 2)
            glVertex2f(self.x - self.size / 2 + (i + 1) * triangle_width, self.y - self.size / 2)
            glVertex2f(self.x - self.size / 2 + i * triangle_width + triangle_width / 2, self.y - self.size / 2 - triangle_height)
            glEnd()


    def move(self):
        directions = [(-CELL_SIZE / 8, 0), (CELL_SIZE / 8, 0), (0, CELL_SIZE / 8), (0, -CELL_SIZE / 8)]
        if not self.direction or check_collision(self.x + self.direction[0]*(1.5), self.y + self.direction[1]*(1.5), self.size):#1.5 is for adjusting
            self.direction = random.choice(directions)                                                                      # the speed of ghost

        new_x = self.x + self.direction[0]*(1.5)
        new_y = self.y + self.direction[1]*(1.5)
        if not check_collision(new_x, self.y, self.size):
            self.x = new_x
        if not check_collision(self.x, new_y, self.size):
            self.y = new_y

    def reset_color(self):
        if self.frightened and time.time() - self.frightened_start_time > 5:
            self.color = self.original_color
            self.frightened = False

# render text
def render_text(text, position, size, color=(255, 255, 255)):
    pygame.font.init() 
    font = pygame.font.Font(None, size)
    text_surface = font.render(text, False, color)
    text_data = pygame.image.tostring(text_surface, "RGBA", True)
    glWindowPos2d(position[0], position[1])
    glDrawPixels(text_surface.get_width(), text_surface.get_height(), GL_RGBA, GL_UNSIGNED_BYTE, text_data)



# Initialize Pac-Man and Ghosts
pacman = PacMan(CELL_SIZE * 1.5, CELL_SIZE * 1.5, CELL_SIZE // 2.5)
ghosts = [
    Ghost(CELL_SIZE * 12, CELL_SIZE * 11.5, CELL_SIZE // 1.5, (1, 0, 0)),  # Red
    Ghost(CELL_SIZE * 13, CELL_SIZE * 11.5, CELL_SIZE // 1.5, (0, 1, 0)),  # Green
    Ghost(CELL_SIZE * 14, CELL_SIZE * 11.5, CELL_SIZE // 1.5, (0, 0, 1)),  # Blue
    Ghost(CELL_SIZE * 15, CELL_SIZE * 11.5, CELL_SIZE // 1.5, (1, 0, 1))   # Pink
]

score = 0
game_won = False
game_lost = False
game_over = False

# Main loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    if not game_over:
        keys = pygame.key.get_pressed()
        if keys[K_LEFT]:
            pacman.change_direction((-CELL_SIZE / 8, 0))
        if keys[K_RIGHT]:
            pacman.change_direction((CELL_SIZE / 8, 0))
        if keys[K_UP]:
            pacman.change_direction((0, CELL_SIZE / 8))
        if keys[K_DOWN]:
            pacman.change_direction((0, -CELL_SIZE / 8))



        pacman.move()
 
        #pacman.mouth_angle = (pacman.mouth_angle + 0.05) % 0.4
        pacman.update_mouth()
        pacman.reset_color()

        dot_score, ate_fruit = check_score_collision(pacman.x, pacman.y, pacman.size)
        score += dot_score
        if ate_fruit:
            pacman.color = (0.5, 0.5, 1)  # Light blue color
            pacman.eaten_fruit_time = time.time()
            for ghost in ghosts:
                ghost.color = (0.5, 0.5, 1)  # Light blue color
                ghost.frightened = True
                ghost.frightened_start_time = time.time()

        for ghost in ghosts:
            ghost.move()
            ghost.reset_color()

        for ghost in ghosts:
            if ghost.frightened and math.hypot(pacman.x - ghost.x, pacman.y - ghost.y) < pacman.size:
                ghosts.remove(ghost)
                score += 30
            elif not ghost.frightened and math.hypot(pacman.x - ghost.x, pacman.y - ghost.y) < pacman.size:
                game_lost = True
                game_over = True

        if not any('.' in row for row in MAP):
            game_won = True
            game_over = True

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    wall_color = (0, 0, 0.5)
    path_color = (0, 0, 0)
    dot_color = (1, 0.8, 0)
    fruit_color = (0.5, 0, 0.5)
    for row in range(ROWS):
        for col in range(COLS):
            x = col * CELL_SIZE
            y = row * CELL_SIZE
            if MAP[row][col] == '#':
                rectangle_draw(x, y, CELL_SIZE, CELL_SIZE, wall_color)
            else:
                rectangle_draw(x, y, CELL_SIZE, CELL_SIZE, path_color)
                if MAP[row][col] == '.':
                    rectangle_draw(x + CELL_SIZE // 2 - 3, y + CELL_SIZE // 2 - 3, 6, 6, dot_color)
                elif MAP[row][col] == 'F':
                    rectangle_draw(x + CELL_SIZE // 2 - 7, y + CELL_SIZE // 2 - 7, 15, 15, fruit_color)

    pacman.draw()

    for ghost in ghosts:
        ghost.draw()

    render_text(f'Score: {score}', (710, 693), 36, (255, 0, 255))

    if game_won:
        rectangle_draw(300, 250, 200, 100, (1, 1, 1))
        render_text("YOU WON", (340, 290), 36, (0, 0, 0))
    elif game_lost:
        rectangle_draw(300, 250, 200, 100, (1, 1, 1))
        render_text("YOU LOST", (340, 290), 36, (0, 0, 0))

    pygame.display.flip()
    pygame.time.wait(10)

pygame.quit()
