.PHONY: clean
clean:
	rm -f index.html
	rm -f index.markdown
	rm -f 20*.html

.PHONY: deploy
deploy:
	make clean
	git checkout gh-pages
	make clean
	git merge master
	./build.rb
	git add *.css *.html assets index.markdown
	git commit -m "build"
	git push
	make clean
	git checkout master
