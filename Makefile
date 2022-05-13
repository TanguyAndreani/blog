.PHONY: clean
clean:
	rm index.html
	rm index.markdown
	rm 20*.html

.PHONY: deploy
deploy:
	git checkout gh-pages
	git merge master
	./build.rb
	git add *.css *.html assets
	git commit -m "build"
	git push
	git checkout master