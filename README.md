[![Drivey screenshot](/readme_assets/screenshot.png?raw=true "Drivey's industrial zone.")](https://rezmason.github.io/drivey)

### Drive it now [here](https://moshix.github.io/nightdriver/).

### Controls
#### Touch
You can use any combination of fingers (or the mouse):
- `Up-Down`, adjust the driving speed.
- `Left-right`, turn the steering wheel.
#### Keyboard
- `Up Arrow`, gas.
- `Down Arrow`, brake.
- `Space Bar`, handbrake.
- `Left Arrow`, steer left.
- `Right Arrow`, steer right.
- `Shift and Control keys`, slow down and speed up the demo.
#### 1 Switch
Constantly drives with a slight turn. Click to switch between left turns and right turns.




## Techniques

Most of the geometry in both Drivey and Drivey.js is just an extrusion of a single curve (a [closed spline](https://threejs.org/docs/#api/en/extras/curves/CatmullRomCurve3)), which runs down the middle of the road. In other words, the demo marches steadily along this curve, regularly dropping points along the side, sometimes suspending them in the air, and afterwards it connects them into shapes. Every solid or dashed line, every wire and pole, is generated in this way, and the level generates them anew each time you visit. There are very few exceptions, such as the clouds and buildings in the City level.
### Car generation
A different process governs the shape of every car. A handful of numbers and decisions are randomly picked— the length of the cabin, for instance, or whether the car is a convertible- and these values are used to create a basic side view diagram of the car:
```
                     T---U------V----------W
                    P----Q------R-----------S
                   /     |      |            \
                  /      |      |             \
  K_______-------L-------M------N--------------O
  |              |       |      |              |
  F--------------G-------H------I--------------J
   \       __    |       |      |      __     /   ====33
    A-----/  \---B-------C------D-----/  \---E
           FA                          RA
```
Once the points in this diagram are computed, the areas between them are filled with extruded boxes; some are thin, some are thick, some are opaque, some are transparent, some are light and some are dark. Combined together, they form the shape of a car.
