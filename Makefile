.PHONY: clean
clean:
	rm index.html
	rm index.markdown
	rm 20*.html

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
