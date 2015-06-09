# Practical 1
Machine Learning, spring 2015

**NOTE:** if you are not reading this from an Oxford CS lab machine, `install-torch.sh` will be completely useless. Please use the **official** installation route instead: <https://github.com/torch/ezinstall>.

## Setup
Most of the lab machines will have Torch precompiled and stored in `/home/scratch/torchshared/torch`. This will speed up installation as the install script (`install-torch.sh`) will detect this automatically and install if so. If you prefer to force the script to download from the internet and not use this directory, which takes longer, you may modify the script yourself. You may install Torch on your personal machine if you like, though due to time constraints and varying system configurations we are unable to support this.

Clone the git repository somewhere and `cd` into it, and run the installation script, which is only intended to be run on the lab machines:
```sh
$ git clone https://github.com/oxford-cs-ml-2015/practical1.git
$ cd practical1
$ bash install-torch.sh
```
It will prompt you to ask if you want to copy the torch installation if it exists, or automatically continue to download if it doesn't exist, in which case setup will take around 5 minutes. In either case, the installation target is the machine's local disk (`/home/scratch`), so you will need to run the script every time you use a different lab machine. You may continue to save your work to your networked home directory, of course.

You should read the practical PDF document as you wait.

After installation completes, the install script will direct you to add Torch to your `PATH` environment variable:
```sh
$ export PATH=/home/scratch/$USER/torch/bin:$PATH
```
You may add this line to your `~/.bash_environment`.
Now you can start an interactive LuaJIT session with Torch loaded using:
```sh
$ th
 
  ______             __   |  Torch7                                   
 /_  __/__  ________/ /   |  Scientific computing for Lua.         
  / / / _ \/ __/ __/ _ \  |                                           
 /_/  \___/_/  \__/_//_/  |  https://github.com/torch   
                          |  http://torch.ch            
	
th> a=0 ; b=1
                                                                      [0.0001s]	
th> a+b
1	
                                                                      [0.0001s]	
th> torch.randn(2,2)
 0.0341  0.0868
-1.8843  0.9053
[torch.DoubleTensor of dimension 2x2]
...
```

**IMPORTANT NOTE**: the script will attempt to install IPython 2.x along with its dependencies if you have a version older than 2.2, which should be the case for most of you. If you do not wish for the script to upgrade IPython, edit the script and comment out the IPython portion for now. We will only need it in a later practical.

# See course page for practicals
<https://www.cs.ox.ac.uk/people/nando.defreitas/machinelearning/>


