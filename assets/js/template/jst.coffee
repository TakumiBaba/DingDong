window.JST = {}
JST = window.JST

# JST['message/userlist'] = _.template(
#   """
#   <div class='user-list-area'>
#     <ul class='user-list'>
#       <% _.each users, function(user){
#         options = {
#           id = user.id
#           source = user.profile_image_urls[0]
#         }
#         var li = window.JST['message/user'](options)
#         %><%= li %> <%
#       }%>
#     </ul>
#   </div>
#   """
#   )

JST['message/page'] = _.template(
  """
  <div id='message_page'>
    <h4>お相手からのメッセージ<small>"このページは応援団は閲覧できません"</small></h4>
    <div class='user-list-column'>
      <ul class='message-user-thumbnail'>
        <% _.each(users, function(user, num){
          var id = user.get('id')
          var first = (num ==0) ? "active": ""
          options = {
            id: id,
            source: "/user/"+id+"/picture",
            first: first
          }
          var li = window.JST['message/user-thumbnail'](options)
          %><%= li %><%
        }) %>
      </ul>
    </div>
    <div id="message-list-view">
      <div class='message-header'>
        <h5></h5>
      </div>
      <div class='message-body'>
        <ul></ul>
      </div>
      <div class='message-footer'>
        <img src='<%= source %>' class='com_img' />
        <div class='reply_box'>
          <textarea class='message' />
          <button class='btn btn-primary send_message'>メッセージを送る</button>
        </div>
        <!-- メッセージポストView -->
    </div>
  </div>
  """
  )

JST['message/user-thumbnail'] = _.template(
  """
  <li id="<%= id %>" class="m_thumbnail_li <%= first %>">
    <img src="<%= source %>" class='img-rounded m_thumbnail' />
  </li>
  """
  )

JST['message/body'] = _.template(
  """
  <li>
    <div class='message_clm'>
      <div class='message_left'><img src="<%= source %>" class='message_img' /></div>
      <div class='message_line'>
        <p><a href="" class='b'><%= name %>さん</a></p>
        <p><%= text %></p>

        <small><%= created_at %></small>
      </div>
    </div>
  </li>
  """
)

JST['like/page'] = _.template(
  """
  <div id='like_page'>
    <h3 class='title_box'>両思い中<small>"どんどんメッセージを送って会う約束をしよう！"</small></h3>
    <div class='each-like info box-inner container likebox'>
      <ul class='like-thumbnail'></ul>
    </div>
    <h3 class='title_box'>お相手が片思い<small>"ピピっと来たら、『いいね』をプッシュ！"</small></h3>
    <div class='your-like info box-inner container likebox'>
      <ul class='like-thumbnail'></ul>
    </div>
    <h3 class='title_box'>自分が片思い</h3>
    <div class='my-like info box-inner  container likebox'>
      <ul class='like-thumbnail'></ul>
    </div>
  </div>
  """
  )

JST['like/thumbnail'] = _.template(
  """
  <li id="<%= id %>" >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href="/user/<%= id %>" class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <button class='like-action btn-block btn btn-primary l_d_<%= state %>'><%= text %></button>
      <a class='to-talk'><span>応援トークをする</span></a></div>
  </li>
  """
  )

JST['message/user'] = _.template(
  """
  <li id=<%= id %> >
    <img src=<%= source %> class='img-rounded m_thumbnail'>
  </li>
  """
  )

JST['matching/userlist'] = _.template(
  """
  <div id='matching_page' class='profile_and_following_view'>
    <h3 class='title_box'>お相手リスト<small>"ビビッと来たら『いいね』をプッシュ！"</small></h2>
    <div class='system_matching box'>
      <div class='sm_side'>
        <ul class='sm_user_list matching_side'>
        </ul>
      </div>
      <div class='sm_main main_box'>
        <div class='matchinguser_menu box_menu'>
          <img class='profile_image pull-left' src='' />
          <h4 class='name'></h4>
          <h5 class='simple_profile'></h5>
          <div class='btn-group'>
            <button class='like btn pink'>いいね！</button>
            <button class='sendMessage btn btn-success'>メッセージを送る</button>
            <button class='recommend btn btn-primary'>友達に勧める</button>
          </div>
        </div>
        <div class='detail_profile'>
          <div class='follower_column'>
            <div class='follower_column_header'>
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
    <h3 class='title_box'>応援団おすすめリスト<small>"お相手にもあなたが紹介されています。"</small></h3>
    <div class='supporter_matching box'>
      <div class='sp_side'>
        <ul class='sp_user_list matching_side'>

        </ul>
      </div>
      <div class='sp_main main_box'>
        <div class='matchinguser_menu box_menu'>
          <img class='profile_image pull-left' src='' />
          <h4 class='name'></h4>
          <h5 class='simple_profile'></h5>
          <div class='btn-group'>
            <button class='like btn btn-primary'>いいね！</button>
            <button class='sendMessage btn btn-success'>メッセージを送る</button>
            <button class='recommend btn btn-inverse'>友達に勧める</button>
          </div>
        </div>
        <div class='detail_profile'>
          <div class='follower_column'>
            <div class='follower_column_header'>
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

JST['sidebar/follow_thumbnail'] = _.template(
  """
  <li>
    <a href="/#/u/<%= id %>">
      <img src=<%= source %> />
      <div><p><%= name %> さん</p></div>
    </a>
  </li>
  """
  )

JST['userpage/page'] = _.template(
  """
  <div id='user_page' class='profile_and_following_view'>
    <h3 class='title_box'>ユーザーページ</h2>
    <div class='box'>
      <div class='user_profiles main_box'>
        <div class='box_menu'>
          <img class='profile_image pull-left' src='<%= image_source %>' />
          <h4 class='name'><%= name %></h4>
          <h5 class='simple_profile'><%= gender_birthday %></h5>
          <div class='btn-group'>
            <button class='like btn pink'>いいね！</button>
            <button class='sendMessage btn btn-success'>メッセージを送る</button>
            <button class='recommend btn btn-primary'>友達に勧める</button>
          </div>
        </div>
        <div class='detail_profile pull-left'>
          <div class='tabbable'>
            <ul class="nav nav-tabs supporter-menu">
              <li class='active'><a href="#detailprofile" data-toggle="tab">プロフィール詳細</a></li>
              <li><a href="#matchinglist" data-toggle="tab">マッチングリスト</a></li>
              <li><a href="#likelist" data-toggle="tab">いいねリスト</a></li>
              <li><a href="#supportertalk" data-toggle="tab">応援団トーク</a></li>
            </ul>
            <div class='tab-content'>
              <!-- プロフィール -->
              <div class="tab-pane active" id="detailprofile"></div>
              <!-- マッチングリスト -->
              <div class="tab-pane" id="matchinglist">
                <h3 class='title_box'>マッチング情報<small>"ピピっと来たら、『いいね』をプッシュ！"</small></h3>
                <div class='system info box-inner container likebox'>
                  <ul class='like-thumbnail'></ul>
                </div>
                <h3 class='title_box'>応援団おすすめ情報<small>"ピピっと来たら、『いいね』をプッシュ！"</small></h3>
                <div class='supporter info box-inner container likebox'>
                  <ul class='like-thumbnail'></ul>
                </div>
              </div>
              <!-- いいねリスト -->
              <div class="tab-pane" id="likelist">
                <h3 class='title_box'>両思い中<small>"どんどんメッセージを送って会う約束をしよう！"</small></h3>
                <div class='each-like info box-inner container likebox'>
                  <ul class='like-thumbnail'></ul>
                </div>
                <h3 class='title_box'>お相手が片思い<small>"ピピっと来たら、『いいね』をプッシュ！"</small></h3>
                <div class='your-like info box-inner container likebox'>
                  <ul class='like-thumbnail'></ul>
                </div>
                <h3 class='title_box'><%= name %>さんが片思い</h3>
                <div class='my-like info box-inner  container likebox'>
                  <ul class='like-thumbnail'></ul>
                </div>
              </div>
              <!-- 応援団トーク -->
              <div class="tab-pane" id="supportertalk">
                <ul class='talk_list'>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  """
  )

JST['userpage/profile'] = _.template(
  """
  <div class='follower_column'>
    <h5>応援団一覧</h5>
    <ul  class='follower-list pull-left'>
    <% _.each(follower, function(f){
      console.log(f);
      options = {
        facebook_url: "https://facebook.com/"+f.facebook_id,
        source: f.profile_image_urls[0],
        name: f.name
      }
      html = window.JST['matching/follower'](options)
      %><%= html %><%
      }) %>
    </ul>
  </div>
  <div class='profile_column pull-left'>
    <h5>プロフィール詳細</h5>
    <table class='table'>
      <tbody>
      <% html = window.JST['userpage/detailProfile'](profile) %>
      <%= html %>
      </tbody>
    </table>
  </div>
  <!-- ここに応援団のメッセージ一覧&投稿画面が出てくる -->
  """
)

JST['userpage/matching-thumbnail'] = _.template(
  """
  <li id=<%= id %> class='user-thumbnail'>
    <img  src=<%= source %> class='img-rounded' />
  </li>
  """
)


JST['matching/user_thumbnail'] = _.template(
  """
  <li id=<%= id %> class='user-thumbnail'>
    <img  src=<%= source %> class='img-rounded' />
  </li>
  """)

JST['matching/reload_list_icon'] = _.template(
  """
  <li class='user-thumbnail matching_reload'>
    <i class='icon-plus'></i>
  </li>
  """
  );

JST['matching/follower'] = _.template(
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
  """
  );

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
        <h3>ユーザ情報</h3>
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
          <div class='follower-column span5'>
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
    <td class='span2 key'>メッセージ</td><td colspan='3'><%= message %></td>
  </tr>
  <% martialHistoryArray = ["---","なし","あり"] %>
  <% childrenArray = ["---","いない","いる(別居)","いる(同居)"] %>
  <tr>
    <td class='key'>結婚歴</td><td><%= martialHistoryArray[martialHistory] %></td>
    <td class='key'>子供の有無</td><td><%= childrenArray[hasChild] %></td>
  </tr>
  <% wantMarriageArray = ["---","すぐにでも","2〜3年のうちに","お相手に合わせる","特に決めてない"] %>
  <% wantChildArray = ["---","結婚したら欲しい","お相手と相談したい","いなくても構わない","欲しくない","特に決めてない"] %>
  <tr>
    <td class='key'>結婚希望時期</td><td><%= wantMarriageArray[wantMarriage] %></td>
    <td class='key'>子どもの希望</td><td><%= wantChildArray[wantChild] %></td>
  </tr>
  <% addressArray = ["---","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県",,"滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"] %>
  <% hometownArray = ["---","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県",,"滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"] %>
  <tr>
    <td class='key'>居住地</td><td><%= addressArray[address] %></td>
    <td class='key'>出身地</td><td><%= hometownArray[hometown] %></td>
  </tr>
  <% jobArray = ["会社員（営業）","会社員（技術）","会社員（企画）","会社員（サービス）","会社員（販売）","会社員（クリエイティブ）","会社員（事務）","会社員（IT）","会社員（その他）","会社役員","会社経営","国家公務員","地方公務員","自営業","専門職","団体職員","派遣社員","アルバイト","家事手伝い","学生","その他"] %>
  <tr>
    <td class='key'>ご職業</td><td><%= jobArray[job] %></td>
    <td class='key'>年収</td><td><%= income %>万円</td>
  </tr>
  <% educationArray = ["---","中学卒","高校卒","短大卒","大卒","大学院卒","その他"] %>
  <% bloodTypeArray = ["---","A","B","O",'AB'] %>
  <tr>
    <td class='key'>学歴</td><td><%= educationArray[education] %></td>
    <td class='key'>血液型</td><td><%= bloodTypeArray[bloodType] %></td>
  </tr>
  <% shapeArray = ["---","スリム","細め","ふつう","ぽっちゃり","グラマー","ガッチリ","太め"] %>
  <tr>
    <td class='key'>年収</td><td><%= height %>cm</td>
    <td class='key'>体型</td><td><%= shapeArray[shape] %></td>
  </tr>

  <% drinkingArray = ["---","毎日飲む","週3～4日飲む","週1～2日程度","たまに飲む","全く飲まない"] %>
  <% smokingArray = ["---","よく吸う","たまに吸う","まったく吸わない"] %>
  <tr>
    <td class='key'>飲酒習慣</td><td><%= drinkingArray[drinking] %></td>
    <td class='key'>喫煙習慣</td><td><%= smokingArray[smoking] %></td>
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

JST['talk/page'] = _.template(
  """
  <div id='talk_page'>
    <h4>応援トーク<span>"お気に入りの人について応援団と大いに語ろう！"</span></h4>
    <ul class='talk_list'>
    </ul>
  </div>
  """
)

JST['talk/wrapper'] = _.template(
  """
  <div class='com_box'>
    <div>
      <img src="<%= source %>" class='com_img'/>
    </div>
    <div class='com_line'>
      <p><%= name %>さんから<%= candidate_name %>さんについて相談があります。</p>
      <p><%= last_update %>★</p>
    </div>
  </div>
  <div class='part_box'>
    <div class='part_img'>
      <img src="<%= candidate_source %>" class="part_img" />
    </div>
    <div class='part_line'>
      <% addressArray = ["---","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県",,"滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"] %>
      <p><%= candidate_name %>さん <%= candidate_age %>歳 / <%= addressArray[address] %>在住</p>
      <% bloodTypeArray = ["---","A","B","O",'AB'] %>
      <p><%= height %>cm <%= bloodTypeArray[blood] %>型</p>
      <p><label>メッセージ:</label><%= profile_message %></p>
      <a href="/#/u/<%= candidate_id %>">詳細を見る</a>
    </div>
  </div>
  <div class='like_box'>
    <span>
      <a href='#'>いいね！(<%= like_count %>)</a>
    </span>
  </div>
  <div class='comments_box'>
    <ul class='comments'>
    </ul>
  </div>

  <div class='com_box'>
    <div>
      <img src='<%= source %>' class='com_img' />
    </div>
    <div class='reply_box'>
      <textarea class='comment_area' />
      <button class='btn btn-primary send_comment'>コメントする</button>
    </div>
  </div>
  """
  )

JST['talk/comment'] = _.template(
  """
  <li>
    <div class='com_box'>
      <div>
        <img src="<%= source %>" class='com_img' />
      </div>
      <div class='com_line'>
        <p><%= message %></p>
        <span><%= created_at %></span>
      </div>

    </div>
  </li>
  """)

JST['supporter/page'] = _.template(
  """
  <div id="supporter_list_page">
    <div id='following'>
      <h3>応援中の仲間</h3>
      <ul class='user_list'>
      </ul>
    </div>
    <div id='follower'>
      <h3>応援してくれている仲間</h3>
      <ul class='user_list'>
      </ul>
    </div>
    <div id='requests'>
      <ul class='user_list'>
      </ul>
    </div>
  </div>
  """
)

JST['supporter/thumbnail'] = _.template(
  """
  <li id="<%= id %>" class='<%= type %>' >
    <div class='thumbnail'>
      <button class='close hide'>&times;</button>
      <a href="/user/<%= id %>" class='to-user'>
        <img src=<%= source %> />
        <h5><%= name %></h5>
      </a>
      <button class='btn btn-danger btn-block remove'>取り消す</button>
  </li>
  """
)