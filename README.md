profiler
========

Create the sprite:

    var p:Profiler = new Profiler();

It'll show a row for every function tracked showing: "[name] [number of times called in this frame] [total time in ms]"
 
    Profiler.start("update");\n
    super.update();//function to track\n
    Profiler.stop("update");\n


And at the start of every frame:

    Profiler.newFrame();
