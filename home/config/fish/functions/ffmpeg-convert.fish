function ffmpeg-convert
    set -l input $argv[1]
    set -l timestamp (date +%Y-%m-%d)
    set -l basename (string replace -r '\.[^.]*$' '' $input)
    set -l output "$basename-$timestamp.mp4"
    set -l logfile "$basename-$timestamp.log"

    ffmpeg -i "$input" \
    -c:v hevc_videotoolbox -profile main10 -allow_sw 0 \
    -quality 70 -b:v 0 -pix_fmt p010le \
    -vf "scale=w='min(iw,3840)':h='min(ih,2160)':force_original_aspect_ratio=decrease" \
    -c:a aac -b:a 320k -ar 48000 -ac 2 \
    -tag:v hvc1 -movflags +faststart \
    -map_metadata 0 -map_chapters 0 \
    "$output" 2>&1 | tee "$logfile"
end
