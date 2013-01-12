### Welcome
HadoopSingleNode is an app that provides a click and play solution for Hadoop on Mac OS X. You can just hit play and debug your MapReduce programs in a blink of an eye.

Here are some screenshots:
![Play](http://i50.tinypic.com/rw4fhy.png)
![Your own jobs](http://i46.tinypic.com/35ycm.png)

### Installing
The repo doesn't contain a dmg image for the app so you need to download the github repository and open the xcode project. After building it in xcode you can use your app!

### Running a job
If Hadoop is up and running you can drag and drop your jar file in the app. If needed you can pass arguments to your Hadoop Job in the arguments field.

The [Hadoop WordCount](http://hadoop.apache.org/docs/r0.20.2/mapred_tutorial.html) can be run by dragging the jar file into the respective drop area and then type this as your argument:

```
WordCount /path/to/input/file /path/to/results/output/
```

### Future releases
This app is really simple and only supports single node setup for Hadoop. For future releases it might be awesome to include several config files for Hadoop so you can run the files on the cluster instead of one single node. 

### Authors and Contributors
This app is developed by Marcel Boersma (@boersmamarcel). All icons from the app are from http://www.glyphish.com/ and the Hadoop server is from Cloudera check http://www.cloudera.com.
All other trademarks are property of their respective owners.

### Support or Contact
Having trouble with HadoopSingleNode? Check out the issue tracker at https://github.com/boersmamarcel/HadoopSingleNode/issues
