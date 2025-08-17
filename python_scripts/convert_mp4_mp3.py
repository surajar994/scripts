import yt_dlp
import sys
import os

def download_audio_as_mp3(youtube_url, output_folder="."):
    ydl_opts = {
        'format': 'bestaudio/best',
        'outtmpl': os.path.join(output_folder, '%(title)s.%(ext)s'),
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
            'preferredquality': '192',
        }],
        'quiet': False,
        'noplaylist': True
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([youtube_url])

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python youtube_to_mp3.py <YouTube_URL>")
        sys.exit(1)

    url = sys.argv[1]
    download_audio_as_mp3(url)
