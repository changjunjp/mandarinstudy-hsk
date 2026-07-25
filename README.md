# MandarinStudy HSK

HSK1中国語学習アプリ（Flutter製）

## 機能タブ

| タブ | 機能 |
|------|------|
| 📖 **単語** | HSK1 150単語の一覧（画像・音声・中日英対応） |
| 📝 **例文** | HSK1 118例文の一覧 |
| 🃏 **暗記** | フラッシュカードモード（単語/例文切替可） |
| ❓ **クイズ** | 四択クイズ（日本語→中国語を選ぶ） |
| 🎧 **リスニング** | TTS音声再生 → 答え合わせ |

## セットアップ

```bash
# 1. Flutterをインストール
# https://docs.flutter.dev/get-started/install

# 2. プロジェクト作成
flutter create --project-name mandarinstudy_hsk mandarinstudy_hsk
cd mandarinstudy_hsk

# 3. このファイル群をプロジェクトフォルダに上書き

# 4. 依存関係インストール
flutter pub get

# 5. 実行
flutter run
```

## Android build
```bash
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

## iOS build (Mac必要)
```bash
flutter build ios
```

## データソース

Firestore (project: `studio-6881016186-e904d`) から取得したHSK1データを
ローカルJSON (`assets/hsk1_data.json`) にバンドル。
オフラインで動作します。
