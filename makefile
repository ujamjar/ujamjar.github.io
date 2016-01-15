clean:
	find . -name "*~" | xargs rm 

server:
	jekyll serve -w
