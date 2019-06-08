for /r %1 %%i in (*) do ( 
Luadec51.exe %%i > %%ic
move /Y %%ic %%i
)
echo "done!"
