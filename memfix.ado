*! memfix: Dealing with the Unix optimistic memory allocation bug 
*! Version  0.0.0 junio 9, 2014 @ 02:58:06
*! Author : Damian Clarke 
*! Contact: damian.clarke@economics.ox.ac.uk

cap program drop memfix
program memfix, rclass
version 8.0

	! free -m | awk '/Mem/ {print $4}' > __oom

	tempname oom
	file open `oom' using __oom, read
	file read `oom' line
	if length("`line'")==0 {
		dis "The call to the Unix system command free has returned non-standard output"
		rm __oom
		exit 272
	}

	local memavail = round(`line'*0.8)
	dis `memavail'
	
	file read `oom' line
	if  r(eof)!=1 {
		dis "The call to the Unix system command free has returned non-standard output"
		rm __oom
		exit 272
	}

	rm __oom
	set max_memory `memavail'm
end
