# Testing

Testing is done manually until a sufficient test framework is found. All of the tests outlined here will be in the form of shell logs. 

---

```
$ quicksand --version
quicksand vX.Y.Z


$ quicksand --help
Usage: quicksand [arguments]
# show help


$ quicksand
Must provide a filename


$ quicksand not-a-real-file
not-a-real-file does not exist


# for all later tests, use the hello.txt fixture:
"hello world" > hello.txt


$ quicksand hello.txt
# [banner]
spinning up ngrok...........done
spinning up static server...done
limiting to 1 downloads
local        : http://127.0.0.1:7000/hello.txt
remote http  : http://xxxxxxxx.ngrok.io/hello.txt
remote https : https://xxxxxxxx.ngrok.io/hello.txt
# go download the file somewhere, then expect
Max downloads (1/1) reached


$ quicksand hello.txt -q
https://xxxxxxxx.ngrok.io/hello.txt
# go download the file somewhere, then expect quicksand to exit silently


$ quicksand hello.txt -B
# banner shouldn't have been printed
spinning up ngrok...........done
spinning up static server...done
limiting to 1 downloads
local        : http://127.0.0.1:7000/hello.txt
remote http  : http://xxxxxxxx.ngrok.io/hello.txt
remote https : https://xxxxxxxx.ngrok.io/hello.txt
# go download the file somewhere, then expect
Max downloads (1/1) reached


$ quicksand hello.txt -B -m 10
spinning up ngrok...........done
spinning up static server...done
limiting to 10 downloads
local        : http://127.0.0.1:7000/hello.txt
remote http  : http://xxxxxxxx.ngrok.io/hello.txt
remote https : https://xxxxxxxx.ngrok.io/hello.txt
# go download the file 10 times, then expect
Max downloads (10/10) reached


$ quicksand hello.txt -d 
https://xxxxxxxx.ngrok.io/hello.txt
# also expect the app to be totally daemonized:
#   - no longer in the foreground
#   - stdout not printing to the shell
#   - able to continue doing other things in the shell
# also expect the app to close itself when the max download limit is reached


# when disconnected from the internet, expect:
$ quicksand hello.txt -B
spinning up ngrok...........Unable to fetch external url


# when disconnected from the internet, expect:
$ sand hello.txt -d
Unable to fetch external url
```
