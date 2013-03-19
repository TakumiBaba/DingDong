window.JST = {}
JST = window.JST

JST['userpage/modal'] = _.template(
  """
  <div id='userpage' class='modal hide fade'>
    <div class='pull-left userpage-sidebar'>
      <ul class='userpage-sidebar-ul'>
      </ul>
    </div>
    <div class='userpage-main'>
      <div class='modal-header'>
        <button class='close' type='button' data-dismiss='modal' aria-hidden='true'>&times;</button>
        <h3>マッチング情報</h3>
      </div>
      <div class='modal-body'>
        <div class='profile'>
          <img class='profile-image pull-left' src='' />
          <h4></h4>
          <h5></h5>
          <div class='btn-group'>
            <button class='like btn btn-primary'>いいね！</button>
            <button class='sendMessage btn btn-success'>メッセージを送る</button>
            <button class='recommend btn btn-inverse'>友達に勧める</button>
          </div>
          <!-- if supporter is true then visible else unvisible -->
          <!-- マッチングリストとかでクリックした人は、左のリストに入り込む -->
          <% if(isSupporter == true){ } %>
          <div class='btn-group supporter-menu'>
            <button class='matching-list btn'>マッチングリスト</button>
            <button class='like-list btn'>いいねリスト</button>
            <button class='dang-talk btn'>応援団トーク</button>
          </div>
        </div>
        <div class='detail-profile'>
          <div class='follower-column'>
            <div class='follower-column-header'>
              <h5>応援団一覧</5>
            </div>
            <div class='follower-column-body'>
              <ul class='follower-list'>
              </ul>
            </div>
          </div>
          <div class='profile-column'>
            <div class='profile-column-header'>
              <h5>プロフィール詳細</5>
            </div>
            <div class='profile-column-body'>
              <table class='table'>
                <tbody>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  """)

JST['userpage/footerUser'] = _.template(
  """
  <li id=<%= id %> class='footer-user'>
    <img  src=<%= source %> />
  </li>
  """)

JST['userpage/follower'] = _.template(
  """
  <li>
      <div class='media'>
        <a href=<%= facebook_url %> >
          <img src=<%= source %> class='pull-left' />
          <div class='media-body'>
            <h5><%= name %></h5>
          </div>
        </a>
      </div>
  </li>
  """)

JST['userpage/followerWithMessage'] = _.template(
  """
  <li>
      <div class='media'>
        <a href=<%= facebook_url %> >
          <img src=<%= source %> class='pull-left' />
          <div class='media-body'>
            <h5 class='media-heading'><%= name %></h5>
        </a>
          <%= text %>
        </div>
      </div>

  </li>
  """)

JST['userpage/detailProfile'] = _.template(
  """
  <tr>
    <td class='span2'>メッセージ</td><td><%= message %></td>
  </tr>
  <%= martialHistoryArray = ["---","なし","あり"] %>
  <tr>
    <td>結婚歴</td><td><%= martialHistoryArray[martialHistory] %></td>
  </tr>
  <%= childrenArray = ["---","いない","いる(別居)","いる(同居)"] %>
  <tr>
    <td>子供の有無</td><td><%= childrenArray[hasChild] %></td>
  </tr>
  <%= wantMarriageArray = ["---","すぐにでも","2〜3年のうちに","お相手に合わせる","特に決めてない"] %>
  <tr>
    <td>結婚希望時期</td><td><%= wantMarriageArray[wantMarriage] %></td>
  </tr>
  <%= wantChildArray = ["---","結婚したら欲しい","お相手と相談したい","いなくても構わない","欲しくない","特に決めてない"] %>
  <tr>
    <td>子どもの希望</td><td><%= wantChildArray[wantChild] %></td>
  </tr>
  <%= addressArray = ["---","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県",,"滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"] %>
  <tr>
    <td>居住地</td><td><%= addressArray[address] %></td>
  </tr>
  <%= hometownArray = ["---","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県",,"滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"] %>
  <tr>
    <td>出身地</td><td><%= hometownArray[hometown] %></td>
  </tr>
  <%= jobArray = ["会社員（営業）","会社員（技術）","会社員（企画）","会社員（サービス）","会社員（販売）","会社員（クリエイティブ）","会社員（事務）","会社員（IT）","会社員（その他）","会社役員","会社経営","国家公務員","地方公務員","自営業","専門職","団体職員","派遣社員","アルバイト","家事手伝い","学生","その他"] %>
  <tr>
    <td>ご職業</td><td><%= jobArray[job] %></td>
  </tr>
  <tr>
    <td>年収</td><td><%= income %>万円</td>
  </tr>
  <%= educationArray = ["---","中学卒","高校卒","短大卒","大卒","大学院卒","その他"] %>
  <tr>
    <td>学歴</td><td><%= educationArray[education] %></td>
  </tr>
  <%= bloodTypeArray = ["---","A","B","O",'AB'] %>
  <tr>
    <td>血液型</td><td><%= bloodTypeArray[bloodType] %></td>
  </tr>
  <tr>
    <td>年収</td><td><%= height %>cm</td>
  </tr>
  <%= shapeArray = ["---","スリム","細め","ふつう","ぽっちゃり","グラマー","ガッチリ","太め"] %>
  <tr>
    <td>体型</td><td><%= shapeArray[shape] %></td>
  </tr>
  <%= drinkingArray = ["---","毎日飲む","週3～4日飲む","週1～2日程度","たまに飲む","全く飲まない"] %>
  <tr>
    <td>飲酒習慣</td><td><%= drinkingArray[drinking] %></td>
  </tr>
  <%= smokingArray = ["---","よく吸う","たまに吸う","まったく吸わない"] %>
  <tr>
    <td>喫煙習慣</td><td><%= smokingArray[smoking] %></td>
  </tr>
  """
  )

JST['userpage/matching-list'] = _.template(
  """
  <div class='box-pink navbar'>
    <div class='box-title pink'>
      <h3>マッチングリスト<small class='white'>"ピピっと来たら、『いいね』をプッシュ！"</small></h3>
      <div id='matching-system' class='info box-inner container row2'>
        <ul class='matching-thumbnail'>
        </ul>
      </div>
    </div>
  </div>
  """)