hoge = '''
div.container
  include module/header
  div#contents.row
    include module/sidebar
    div#main.span9
      div.box-green.navbar
        div.box-title.green
          h3 婚活者登録
        div.info.box-inner.container
          form.form-horizontal(action='./signup', method='POST')
            div.control-group
              label.control-label(for='name') 名前
              div.controls
                input(type='text',name='name', id='name', required)
            div.control-group
              label.control-label(for='gender') 性別
              div.controls
                label.radio.inline
                  input(type='radio',name='male', id='gender_male', value='male')
                  男
                label.radio.inline
                  input(type='radio',name='female', id='gender_female', value='female')
                  女
            div.control-group
              label.control-label(for=''age'') 年齢
              div.controls
                input(type='number',name='age', id='age', required)
            div.control-group
              label.control-label(for=''range_of_age_min'') 相手の希望年齢
              div.controls
                input.span2(type='number', name='range_of_age_min', id='range_of_age_min', required)
                span.help-inline から
                input.span2(type='number', name='range_of_age_max', id='range_of_age_max', required)
                span.help-inline まで
            div.control-group
              label.control-label(for=''profile_message'') メッセージ
              div.controls
                textarea.span5(rows=''3'', name='profile_message',id='profile_message', required)
            input(type='hidden', name='id', id=''id'')
            input(type='hidden', name='username', id=''username'')
            div.control-group
              div.controls
                button.btn.btn-primary(type='submit') 登録する
                button.btn(type='button') キャンセル
div#myModal.modal.hide.fade(tabindex=''-1'', role=''dialog'', aria-labelledby=''myModalLabel'', aria-hidden=''true'')
  div.modal-header
    h3#myModalLabel 規約に同意してください
  div.modal-body
    div.control-group
      label.checkbox
        input(type='checkbox', value='', id=''is-married'')
        p 結婚していません
    div.control-group
      label.checkbox
        input(type='checkbox', value='', id=''use-policy'')
        p 利用規約に同意する
    div.control-group
      label.checkbox
        input(type='checkbox', value='', id=''over-age'')
        p 22歳以上です

  div.modal-footer
    button#agreement.btn.btn-primary 同意する
    button#disagreement.btn 同意しない
'''
return hoge

# hoge = "hoge"