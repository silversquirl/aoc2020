#!/bin/sh
sed -E 's/^(.+)-(.+) (.): /\1 \2 \3 /' | while read -r start end ch pass; do
	# count="$(echo "$pass" | tr -cd "$ch" | wc -c)"
	# if [ "$count" -ge "$start" ] && [ "$count" -le "$end" ]; then
	# 	echo
	# fi
	echo "$pass" | sed -E "s/^.{$(( start - 1 ))}(.).{$(( end - start - 1 ))}(.).*/\1 \2/" | {
		read a b
		[ "$a" = "$ch" ]; a="$?"
		[ "$b" = "$ch" ]; b="$?"
		[ "$a" -ne "$b" ] && echo
	}
done | wc -l
