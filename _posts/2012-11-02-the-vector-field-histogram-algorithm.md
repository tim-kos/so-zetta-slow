---
layout: post
title: The Vector Field Histogram algorithm
tags: [en-us, robotics, vector-field-histogram, vfh, path planning]
---

I'm taking a course on real-time systems at my college. In one of the projects, we have to build a system that uses "concurrent programming" design approaches, with various threads acting separately and communicating through queues.

For this, I remembered some papers I've read in Brazil about path planning algorithms and one of them - the Vector Field Histogram (VFH) - sounded sufficiently simple to be implemented in two weeks. Of course, I had to implement the *whole* system: communication with sensors, some kind of output (in my case, via UART), the interthread communication mechanism, etc.

Well, my background with Ruby made me design it so the VFH algorithm could be substituted by a stub, making the system easily testable. So I did it. However, I had a surprise, a very strange one for someone accostumed with high-level languages and an OS: there's no heap on the microcontroller, so I can't use `malloc()`. Damn.

Well, the professor like my coding style and accepted the project as is, after talking about implementing a memory allocation function myself. Anyway, I wrote this post to explain how VFH works.

## What is path planning?

Suppose you have a robot wandering in a room with some sonar sensors attached to it. It's "seeing" lots of distance measures from the surroundings, but how can it find and avoid obstacles?

![Robot with rangefinder sensors and some obstacles around it][robot_rangefinders]

That's where a path planning algorithm is used. Of course, sonars (and, more generally, rangefinders) are one way to do it; cameras and computer vision algorithms are another one.

There are two types of path planning: local and global. The former deals with more immediate concerns such as "avoid a crash", while the latter is concerned with how to get to the objective, usually in an optimal way.

The VFH is an example of local path planning.

## Data structures used in the algorithm

There are two main data structures used in VFH: the Certainty Grid, which is a kind of long-term memory about the place the robot is in, and the Polar Histogram, with bins representing the "obstacle density" in each direction.

![Certainty grid with a robot and a subgrid/window around it.][certainty_grid]

In my (very ugly) drawing, you can see what the grid looks like. The robot is the ball in position (4, 4) and the obstacle is comprised of the points {(7, 4), (7, 5), (7, 6)}.

![Polar histogram corresponding to the certainty grid][polar_histogram]

## Steps of the algorithm

The algorithm is pretty straightforward. I won't go into much detail about how the calculations are made 

1_ The Certainty Grid is updated.

2_ A moving window centered around the robot is generated.

3_ A polar histogram of the obstacle densities of the moving window is created.

4_ The control signals are generated from the polar histogram.

## My implementation

I made my implementation in pure C, using only `stdlib.h` and `math.h`. Of course,  it's open source and [available on Github](https://github.com/agarie/vector-field-histogram).

I'll probably write Ruby bindings someday, as it would be a relatively simple and interesting project: controlling robots with it sounds fun. :)

## References

1. BORENSTEIN, J.; KOREN, Y. _The Vector Field Histogram - Fast Obstacle Avoidance for Mobile Robots_. IEEE Journal of Robotics and Automation Vol 7, No 3, June 1991, pp. 278-288.
2. BORENSTEIN, J.; KOREN, Y. _Real-Time Obstacle Avoidance for Fast Mobile Robots_. IEEE Transactions on Systems, Man and Cybernetics, Vol. 19, No. 5, Sept./Oct. 1989, pp. 1179-1187.

[robot_rangefinders]: http://i4.photobucket.com/albums/y108/SirAuronz/FF1FF099-2F5F-4B90-B599-E4670938D8EB-5009-000004A83641DB10.jpg
[certainty_grid]: http://i4.photobucket.com/albums/y108/SirAuronz/7C61B6F1-7E58-4C5D-A7CD-38081915C40D-5009-000004A8343F00AF.jpg
[polar_histogram]:  http://i4.photobucket.com/albums/y108/SirAuronz/CD447717-1BCC-4DB2-99D8-B25F3A4FF911-5009-000004A837F29B18.jpg