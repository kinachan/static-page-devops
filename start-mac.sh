#!/bin/sh

for ARGUMENT in "$@"
do
  KEY=$(echo $ARGUMENT | awk -F= '{print $1}')
  VALUE=$(echo $ARGUMENT | awk -F= '{print $2}')   

  case "$KEY" in
    PORT)              PORT=${VALUE} ;;
    *)   
  esac
done

if [ -z "$PORT" ]; then
  PORT=8080
fi

printf "PORT $PORT 番でサーバーを作成します。"

rm -rf .git
rm .gitignore

yarn init --yes
mkdir src
mkdir src/styles
mkdir src/styles/css
mkdir src/js

yarn add gulp
yarn add gulp-sass
yarn add gulp-clean-css
yarn add gulp-rename
yarn add gulp-uglify
yarn add sass
yarn add browser-sync
yarn add @vercel/edge
yarn add basic-auth
yarn add static-auth
yarn add qrcode-terminal --dev

# create File
cat <<EOF >.gitignore
how-to-use.md
node_modules
yarn.lock
start.sh
start-mac.sh
deploy-flow.md
EOF

# create File
cat <<EOF >src/index.html

<!DOCTYPE html>
<html lang="ja">

<head>
  <meta charset="utf-8">
  <title>タイトルを変更してください</title>

  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width,initial-scale=1.0" />

  <meta name="description" content="【ページの説明文】" />

  <!-- アイコン
  <link rel="shortcut icon" href="【ファイル名.ico】" />
  <link rel="apple-touch-icon-precomposed" href="【画像のパス/apple-touch-icon-precomposed.png】" />

  facebookのOGP
  <meta property="og:url" content="【ページのURL】" />
  <meta property="og:title" content="【ページのタイトル】" />
  <meta property="og:type" content="website" />
  <meta property="og:description" content="【ページの説明】" />
  <meta property="og:image" content="【サムネイル画像のURL】" />
  <meta property="og:site_name" content="【サイトのタイトル】" />
  <meta property="fb:app_id" content="【appID】" />
  <meta property="og:locale" content="ja_JP" />

  TwitterのOGP
  <meta name="twitter:card" content="【カードの種類】" />
  <meta name="twitter:site" content="【@ユーザー名】" />
  <meta name="twitter:description" content="【ページの説明】" />
  <meta name="twitter:image:src" content="【サムネイル画像のURL】" /> -->

  <link rel="stylesheet" href="./styles/css/index.css" type="text/css">
</head>

<body>
  <main>
    <h1>開発環境<span class="is-small">の</span>構築が<span class="is-bold">完了</span>しました。</h1>

    <section>
      <p>srcディレクリを参照して、ソースを修正してください。</p>
      <p>cssはsrc/styles/index.scssにあります。scssファイルを何か適当に編集してもらうとcssファイルが生成されます。</p>
      <p class="is-bold">jsはsrc/js/index.jsにあります。</p>
    </section>
  </main>
  <script src="./js/index.js"></script>
</body>

</html>
EOF

# create File	
curl https://unpkg.com/ress@5.0.2/dist/ress.min.css -o src/styles/_reset.css

# create File	
cat <<EOF >src/styles/_debug.scss	
// * {	
// outline: 1px solid magenta;	
// }	
EOF

# create File
cat <<EOF >src/styles/index.scss
@use 'sass:meta';

@import '_reset';
@import '_debug';

/* mixin map-get*/
\$breakpoint: (
  sp: 'screen and (max-width: 767px)',
  tab: 'screen and (min-width: 768px)',
  pc: 'screen and (min-width: 992px)',
  bigPc: 'screen and (min-width: 1100px)'
);


@mixin mediaQuery(\$device) {
  @media #{map-get(\$breakpoint, \$device)} {
    @content;
  }
}

\$boldClassName: 'is-bold';
\$smallClassName: 'is-small';

/// 文字関連のmixin
/// 
/// @type {List} \$defines - デバイス別の文字関連の定義
/// @prop {Map} device - pc or sp or tab またはブレークポイントに追加した定義
/// @prop {Map} size - font-size
/// @prop {Map} weight, - font-weight,
@mixin typography(\$defines) {
  @each \$define in \$defines {
    @if map-has-key(\$define, 'device') {
      @include mediaQuery(map-get(\$define, 'device')) {
        color: map-get(\$define, 'color');
        font-size: map-get(\$define, 'size');
        font-weight: map-get(\$define, 'weight');
        text-align: map-get(\$define, 'text-align');
        line-height: map-get(\$define, 'line-height');
        font-style: map-get(\$define, 'style');
        font-family: map-get(\$define, 'family');
        letter-spacing: map-get(\$define, 'letter-spacing');

        // is-bold
        @if map-has-key(\$define, 'isBold') {
          \$boldStyle: map-get(\$define, 'isBold');
          .#{\$boldClassName} {
            color: map-get(\$boldStyle, 'color');
            font-size: map-get(\$boldStyle, 'size');
            font-weight: map-get(\$boldStyle, 'weight');
            text-align: map-get(\$boldStyle, 'text-align');
            line-height: map-get(\$boldStyle, 'line-height');
            font-style: map-get(\$boldStyle, 'style');
            font-family: map-get(\$boldStyle, 'family');
            letter-spacing: map-get(\$boldStyle, 'letter-spacing');
          }
        }

        // is-small
        @if map-has-key(\$define, 'isSmall') {
          \$smallStyle: map-get(\$define, 'isSmall');
          .#{\$smallClassName} {
            color: map-get(\$smallStyle, 'color');
            font-size: map-get(\$smallStyle, 'size');
            font-weight: map-get(\$smallStyle, 'weight');
            text-align: map-get(\$smallStyle, 'text-align');
            line-height: map-get(\$smallStyle, 'line-height');
            font-style: map-get(\$smallStyle, 'style');
            font-family: map-get(\$smallStyle, 'family');
            letter-spacing: map-get(\$smallStyle, 'letter-spacing');
          }
        }
      }
    }
  }
}


/// マージン関連のmixin
@mixin margin(\$defines) {
  @each \$define in \$defines {
    @if map-has-key(\$define, 'device') {
      \$device: map-get(\$define, 'device');

      @if (\$device == all) {
        margin-top: map-get(\$define, 'top');
        margin-left: map-get(\$define, 'left');
        margin-right: map-get(\$define, 'right');
        margin-bottom: map-get(\$define, 'bottom');
        
      } @else {
        @include mediaQuery(\$device) {
          margin-top: map-get(\$define, 'top');
          margin-left: map-get(\$define, 'left');
          margin-right: map-get(\$define, 'right');
          margin-bottom: map-get(\$define, 'bottom');
        }
      }
    }
  }
}

/// パディング関連のmixin
@mixin padding(\$defines) {
  @each \$define in \$defines {
    @if map-has-key(\$define, 'device') {
      \$device: map-get(\$define, 'device');

      @if (\$device == all) {
        margin-top: map-get(\$define, 'top');
        margin-left: map-get(\$define, 'left');
        margin-right: map-get(\$define, 'right');
        margin-bottom: map-get(\$define, 'bottom');
        
      } @else {
        @include mediaQuery(\$device) {
          padding-top: map-get(\$define, 'top');
          padding-left: map-get(\$define, 'left');
          padding-right: map-get(\$define, 'right');
          padding-bottom: map-get(\$define, 'bottom');
        }
      }
    }
  }
}

@mixin newLine() {
  span.newline {
    display: block;
  }
}


main {
  @include padding(((
    device: all,
    top: 32px,
    left: 32px,
    right: 32px,
    bottom: 32px,
  ), ));

  h1 {
    @include margin(((
      device: pc,
      bottom: 100px,
      top: 50px,
      left: 20px,
    ), (
      device: sp,
      bottom: 20px,
    )));
  
    @include typography(((
      device: 'bigPc',
      size: 200px,
    ),(
      device: 'pc',
      size: 48px,
      weight: 600,
      color: red,
      isBold: (
        weight: 700,
        size: 50px,
      ),
      isSmall: (
        weight: 700,
        size: 30px,
      )
    ), (
      device: 'sp',
      size: 20px,
    )));  
  }

  section {
    background-color: aliceblue;
    @include padding(((
      device: pc,
      top: 20px,
      left: 10px,
      right: 10px,
      bottom: 10px,
    ), (
      device: sp,
      top: 10px,
      left: 8px,
      right: 8px,
      bottom: 10px,
    )))
  }
}
EOF

# create File
cat <<EOF >src/js/index.js
  console.log('hello javascript');
EOF

# create File
cat <<EOF >gulpfile.js
const gulp = require("gulp");
const browserSync = require("browser-sync");
const sass = require('gulp-sass')(require('sass'));
const cleanCss = require('gulp-clean-css');
const rename = require("gulp-rename");
const uglify = require("gulp-uglify");
const qrCode = require('qrcode-terminal');	
const getLocalIP = () => {	
  try {	
    const { networkInterfaces } = require('os');	
    const nets = networkInterfaces();	
    const ipAddress = nets['Wi-Fi'].find(x => x.family === 'IPv4').address;	
    return ipAddress;	
  } catch (err) {	
    return null;	
  }	
}


gulp.task("browserSyncTask", function (done) {
  const ipAddress = getLocalIP();
  if (ipAddress) {	
    qrCode.generate("http://" + ipAddress + ":$PORT", { small: true }, (result) => {	
      console.log(`[INFO] スマホではこの環境で表示してください。`)	
      console.log(result);	
    });
  }

  browserSync({
    port: $PORT,
    server: {
      baseDir: "src", // ルートとなるディレクトリを指定
    },
    host: ipAddress || '0.0.0.0',
  });
  done();
});


gulp.watch('src/**', function (done) {
  browserSync.reload();
  done();
});

gulp.task('deploy', (done) => {
  gulp.src('src/css/index.css')
    .pipe(cleanCss())
    .pipe(rename({
      suffix: '.min',
    }))
    .pipe(gulp.dest('src/css'));


  gulp.src('src/js/index.js')
    .pipe(uglify())
    .pipe(rename({
      suffix: '.min'
    }))
    .pipe(gulp.dest('src/js'))
  done();
});


gulp.watch('src/styles/**/*.scss', function (done) {
  return gulp.src('src/styles/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('src/styles/css'));
})

gulp.task('exec', gulp.series('browserSyncTask'))
EOF


cat <<EOF >src/middleware.js


// このファイルは納品しません。Basic認証用に使用します。
import { next } from "@vercel/edge";

export const config = {
  matcher: '/(.*)',
};

export default function middleware(request) {
  const authorizationHeader = request.headers.get("authorization");

  if (authorizationHeader) {
    const basicAuth = authorizationHeader.split(" ")[1];
    const [user, password] = atob(basicAuth).toString().split(":");

    if (user === process.env.BASIC_AUTH_USER && password === process.env.BASIC_AUTH_PASSWORD) {
      return next();
      // 終了
    }
  }

  return new Response("Basic Auth required", {
    status: 401,
    headers: {
      "WWW-Authenticate": 'Basic realm="Secure Area"',
    },
  });
}
EOF

# create File
cat <<EOF >package.update.js
const fs = require('fs');

const json = fs.readFileSync('./package.json', {encoding: 'utf-8'});
const packages = JSON.parse(json) ;

packages['scripts'] = {
  dev: 'gulp exec',
  deploy: 'gulp deploy'
}

fs.writeFileSync('package.json', JSON.stringify(packages, null, 2), {encoding: 'utf-8'});
EOF

node package.update.js
rm package.update.js

npx sass src/styles/index.scss:src/styles/css/index.css

# create File
cat <<EOF >deploy-flow.md


# デプロイの手順のやり方

1. Githubにアップロードする(必ずPrivateリポジトリで作成)
1. Githubにpull

https://vercel.com にアクセス

### Githubと連携する


Root Directoryをsrcに設定する。

環境変数を作成する。(Environment Variables)

BASIC_AUTH_USER=任意の値
BASIC_AUTH_PASSWORD=任意の値

deploy実行でルートディレクトリにindex.htmlが反映されます！
EOF

printf "\033[35m -----------------------------------\035\n"

printf "\033[32m 終了しました！！！ \033[m\n"
printf "\033[35m bash上でyarn run devを実行してください \033[m\n"


# プロンプトを表示して y/n の入力を求める
read -p "gitの設定を続けますか?ここで終わっても大丈夫です。 (y/n): " answer

# 入力が 'y' または 'Y' の場合
if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    echo "Continuing..."
    # 続く処理をここに記述
else
    echo "Exiting."
    exit 0
fi

read -p "リポジトリのURLを入力して下さい: " repo
echo $repo

git init
git add *
git commit -m "first commit"
git branch -M main
git remote add origin $repo
git push -u origin main

echo -e "\033[32m Gitの設定が終わりました！！！ \033[m"
