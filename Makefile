.PHONY: clean
clean:
	rm -f index.html
	rm -f index.markdown
	rm -f 20*.html

.PHONY: deploy
deploy:
	# harmless
	make clean

	# could fail but won't mess up any file
	git checkout gh-pages

	# harmless
	make clean

	# no conflict possible because we never directly
	# modify files in this branch
	git merge master

	# harmless, produces HTML files
	./build.rb

	# if previous step didn't fail (build.rb may fail horribly in its current state!)
	git add *.css *.html assets index.markdown
	git commit -m "build"
	git push

	# for CLI-comfort, go back to initial state
	make clean
	git checkout master
