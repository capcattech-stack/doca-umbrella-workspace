# Feature Specification: Project Planning - Audio Storage Migration and Quality Jazz Seed

> Feature ID: `011-project-planning-audio-storage-migration-and-quality-jazz-seed`
> Created: `2026-07-04`
> Status: Draft
> Source Prompt: Tôi muốn chuyển đổi giải pháp lưu trữ file âm thanh từ trực tiếp lên supabase. Để giải quyết việc lưu trữ nhiều file âm thanh hơn. Về âm nhạc tôi muốn bạn tìm tải những file nhạc jazz có chất lượng tương tự 2 play list đang có để bỏ vào kho. Hãy tìm giải pháp tải tự động.

## 1. Purpose

The purpose of this feature is to move the website's ambient audio assets from local storage in the Git repository to Supabase Storage. This resolves repository bloat (currently ~150MB of audio in Git) and allows for a larger, more flexible music library. Additionally, we will build an automated Python script to search, download, and upload high-quality public domain jazz tracks (pre-1926) from the Internet Archive (Archive.org) directly to Supabase, updating the website's music player configuration.

## 2. User Stories

- As a Developer, I need to store large audio assets in Supabase Storage instead of Git so that the repository remains lightweight and deployments are fast.
- As a Site Administrator, I need an automated script to search and download vintage public domain jazz tracks and sync them to Supabase so that I can easily refresh the playlist without manual work.
- As a Site Visitor, I want to listen to high-quality, legally compliant vintage jazz music on the website that loads quickly and plays smoothly.

## 3. Functional Requirements

- `FR-001`: The system MUST utilize a public Supabase Storage bucket (e.g., named `audio` or `music`) to host the audio files.
- `FR-002`: The system MUST provide an automated Python script (`sync_music.py`) that queries the Internet Archive API to find early jazz/swing sound recordings published before 1926 (which are in the public domain).
- `FR-003`: The sync script MUST download these public domain MP3 tracks, verify their metadata (title, artist, duration), and upload them directly to the Supabase Storage bucket using the Supabase REST API.
- `FR-004`: The sync script MUST generate or update a playlist configuration (as a JSON file in the website project or in a Supabase DB table) containing the track titles, artists, durations, and public Supabase Storage URLs.
- `FR-005`: The website's audio player in [index.astro](file:///Users/ricyuan/CAPCAT/doca-affiliate-web/src/pages/index.astro) MUST be updated to fetch and play tracks from this playlist configuration using the Supabase URLs.

## 4. Non-Functional Requirements

- `NFR-001`: Performance: Audio files downloaded from Archive.org should be compressed/encoded (e.g., MP3 128kbps) to optimize bandwidth consumption and ensure fast playback on mobile devices.
- `NFR-002`: Security: The Supabase Storage bucket must allow public read access for playback, but restrict write/delete access to authenticated requests using the Supabase `service_role` key.
- `NFR-003`: Reliability: The sync script should handle API errors, incomplete downloads, and duplicate uploads gracefully.

## 5. Acceptance Criteria

- `AC-001`: Given the `sync_music.py` script is executed with valid Supabase credentials, when it runs, then it successfully creates/accesses the bucket, downloads public domain jazz tracks, and uploads them to Supabase Storage.
- `AC-002`: Given the sync is complete, when the website homepage is loaded, then the audio player fetches and plays tracks directly from the Supabase public URLs.
- `AC-003`: Given the local `/public/audio/` directory, when migration is approved, then the local large `.m4a` files are deleted from the repository to reclaim space.

## 6. Clarifications

- [NEEDS CLARIFICATION: Do we want the playlist to be loaded dynamically from a Supabase database table at runtime, or compiled into a static JSON file in the website during build time? Static JSON is simpler and faster, whereas a database table is real-time dynamic.]
- [NEEDS CLARIFICATION: Are there specific target artists or jazz tracks from the 1920s that are preferred, or is any high-quality public domain swing/jazz acceptable?]

## 7. Constraints

- Must use Supabase Storage for audio hosting.
- Audio files must be royalty-free or public domain.
- Must run in a standard Python 3.9+ environment.

## 8. Risks

| Risk | Impact | Mitigation |
| --- | --- | --- |
| Large file upload failures | High | Implement chunked uploads or verify file size limits (default 100MB on Supabase). |
| Archive.org API rate limits | Medium | Implement retry logic and caching of search results. |
| Inconsistent audio quality | Medium | Filter search results for high-bitrate MP3 files and log audio properties. |

## 9. Traceability

| Requirement | Plan Section | Tasks | Verification |
| --- | --- | --- | --- |
| `FR-001` | TBD | TBD | TBD |
| `FR-002` | TBD | TBD | TBD |
| `FR-003` | TBD | TBD | TBD |
| `FR-004` | TBD | TBD | TBD |
| `FR-005` | TBD | TBD | TBD |
