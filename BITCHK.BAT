call TOOL/md5 S1.BIN md5
if "%md5%" equ "1bc674be034e43c96b86487ac69d9293" (
      echo MD5 identical!
) else (
      echo MD5 does not match.
)
pause