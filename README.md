# Axis Stream Tools — Community Edition

**Free ACAP for Axis cameras: Live Streaming**

Axis Stream Tools CE turns any Axis network camera into a YouTube Live streaming device.
The app runs directly on the camera as an ACAP (Axis Camera Application Platform) —
no PC, no server, no additional hardware required.

---

## Features

### Streaming
- **YouTube Live RTMP streaming** — enter your stream key and go live
- **Bundled FFmpeg** — statically compiled FFmpeg 6.1.2 included, no separate installation needed
- **Resolution support** — 360p, 480p, 720p, 1080p, and 4K (3840x2160)
- **Auto-start** — stream starts automatically after camera boot (configurable)
- **Auto-reconnect** — exponential backoff (30s → 60s → 120s → 240s) or static user-defined interval

### Audio
- **Silent audio** — auto-generates a muted audio track (YouTube requires audio)
- **Network audio file** — loops an audio file from a mounted network share (SMB/NFS)
- **Uploaded audio file** — upload MP3, WAV, OGG, FLAC, or AAC files to internal storage or SD card
- **Audio file management** — upload, select, delete files via the web UI
- **Audio health monitoring** — automatic stream restart if audio source becomes unavailable

### Monitoring
- **Live bitrate** indicator with progress bar (kbit/s or Mbit/s)
- **CPU load** indicator with color-coded progress bar (green / yellow / red)
- **SoC temperature** with color-coded display and auto-detection of thermal source
- **Camera snapshot** preview in the Stream Control card
- **Restart counter** showing reconnect attempts

### Email Notifications (SMTP)
- Notification when the stream **stops permanently**
- Alert when **restart count exceeds a configurable threshold** within a time window
- Customizable email **subjects and body templates** with placeholders
- **Test email** button to verify SMTP configuration
- Supports SMTP with STARTTLS (port 587) and SMTPS (port 465)

### Settings Management
- **Export** all settings as a JSON file (sensitive fields masked)
- **Import** settings from a previously exported file
- Filename includes date, app name, version, camera model and serial number

### User Interface
- Clean, responsive **web UI** built with Bootstrap 5
- **Dark mode / light mode** toggle with persistent preference
- Floating **Save Configuration** button
- **About page** with device info, credits, and license information
- **Changelog** page with full version history

---

## Download

Download the latest `.eap` package from the
[**Releases**](https://github.com/NFDiJee/axis-stream-tools/releases) page.

Two builds are provided for each release:

| File | Architecture | Cameras |
|---|---|---|
| `Axis_Stream_Tools_CE_*_aarch64.eap` | aarch64 | ARTPEC-8, ARTPEC-9, CV25 (most current models) |
| `Axis_Stream_Tools_CE_*_armv7hf.eap` | armv7hf | ARTPEC-7 and older |

> **How to find your architecture:**
> Open the camera's web interface and go to **System > Plain Config > Properties > System > Soc**.
> Or install the app and check the **About** page — it shows the chip and architecture.

---

## Installation

1. Open the camera's web interface
2. Go to **Apps** > **Add app**
3. Upload the `.eap` file matching your camera's architecture
4. Start the app
5. Click the app's **Open** button or navigate to its settings page

The app will appear in the camera's app list and can be started/stopped from there.

---

## Quick Start

1. **Install** the `.eap` on your camera (see above)
2. Open the app's **settings page**
3. Enter your **YouTube RTMP URL** (default: `rtmp://a.rtmp.youtube.com/live2`)
4. Enter your **YouTube Stream Key** (from YouTube Studio > Go Live > Stream)
5. Enter **Camera Credentials** (an admin user on the camera for RTSP access)
6. Click **Start Streaming**

> **Note:** The camera credentials are needed because the ACAP accesses the camera's
> RTSP video stream internally. This requires a local admin account, not the VAPIX
> service account.

---

## Configuration Details

### Stream Settings
| Setting | Description |
|---|---|
| YouTube URL | RTMP endpoint (default: `rtmp://a.rtmp.youtube.com/live2`) |
| Stream Key | Your YouTube Live stream key |
| Stream Name | A label for this stream, used in email notification templates |
| Camera User / Password | Admin credentials for RTSP access to the camera's video stream |
| Resolution | Video resolution: 360p, 480p, 720p, 1080p, or 4K |

### Audio Settings
| Setting | Description |
|---|---|
| Silent | Generates a muted audio track automatically |
| Network file | Path to an audio file on a mounted network share |
| Uploaded file | Select from files uploaded to internal storage or SD card |

### Reconnect Settings
| Setting | Description |
|---|---|
| Auto Restart | Automatically restart the stream if FFmpeg exits |
| Reconnect Mode | `backoff` (30s → 60s → 120s → 240s) or `static` (fixed interval) |
| Reconnect Delay | Delay in seconds for static mode |

### Email Notification Settings
| Setting | Description |
|---|---|
| Enable Notifications | Master switch for email alerts |
| Notify on Stop | Send email when the stream stops permanently |
| Notify on Restart Threshold | Send email when restart count exceeds threshold in time window |
| SMTP Server / Port | Your email server (e.g., `smtp.gmail.com`, port 587) |
| SMTP Username / Password | SMTP login credentials (for Gmail: use an App Password) |

---

## FFmpeg Notice

This ACAP bundles a statically compiled **FFmpeg 6.1.2** binary that is
cross-compiled during the Docker build process.

FFmpeg is licensed under the **GNU General Public License v2.0 or later (GPLv2+)**.

The unmodified FFmpeg source code used in this build is available at:
https://ffmpeg.org/releases/ffmpeg-6.1.2.tar.xz

The [Dockerfile](Dockerfile) in this repository documents the exact build
configuration and compile flags used to produce the bundled binary.

---

## License

This project is licensed under the [MIT License](LICENSE).

See [NOTICE](NOTICE) for third-party component licenses.

---

## Credits

| Component | Author | License |
|---|---|---|
| ACAP helper library (ACAP.c / ACAP.h) | Fred Juhlin — [pandosme](https://github.com/pandosme) | MIT |
| cJSON | Dave Gamble and contributors — [DaveGamble/cJSON](https://github.com/DaveGamble/cJSON) | MIT |
| FFmpeg | FFmpeg team — [ffmpeg.org](https://ffmpeg.org) | GPLv2+ |
| Bootstrap 5 | Bootstrap team — [getbootstrap.com](https://getbootstrap.com) | MIT |
| jQuery 3.7.1 | OpenJS Foundation — [jquery.com](https://jquery.com) | MIT |
| **Community Edition** | **Dirk Jensen** — [schluettsiel-webcam.de](https://schluettsiel-webcam.de) | MIT |
