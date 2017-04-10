# hand-recognition
<p>This a hand reconition based on geometry </p>

<p>In order to implement a hand geometry recognition system we extract relevant features from the hand contour and use a
classification algorithm to determine the similarity of the tested hand with the template hands to
determine to which class/person the hand belongs to</p>

<p>The classifier function is called by :
<p>classifier('handtrainfile.txt','handtestfile.txt','output-path-for-edited-training-file','output-path-foredited-test-file')
The outputs are:
<p>1. An edited testfile, named "testfile_output.txt" -- where the word test is replaced on each line by
the results of our classifier,
<p>2. An edited trainfile, named "trainfile_output.txt " -- where the true class is replaced on each line
by the results of our classifier
