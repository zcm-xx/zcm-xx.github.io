{% if theme.alipay or theme.wechatpay %}

<blockquote class="blockquote-center" style="color: #ccc;">
    ------------- <i class="fa fa-apple"></i> 感谢您的阅读 <i class="fa fa-apple"></i> -------------
</blockquote>
  <span id="inline-green" style="border-radius:3px;">作者</span>：<a class="link-blue" href="" target="_blank">Zang Ma</a><br/>有问题请 <a class="link-blue" href="https://zcm-xx.github.io/guestbook" target="_blank">留言</a> 或者QQ邮箱留言 <span>1759156488@qq.com</span>。

  <div style="padding: 10px 0; margin: 20px auto; width: 90%; text-align: center;">
    <div>{{ theme.reward_comment }}</div>
    <button id="rewardButton" disable="enable" onclick="var qr = document.getElementById('QR'); if (qr.style.display === 'none') {qr.style.display='block';} else {qr.style.display='none'}">
      <span>赏</span>
    </button>
    <div id="QR" style="display: none;">
      {% if theme.wechatpay %}
        <div id="wechat" style="display: inline-block">
          <img id="wechat_qr" src="{{ theme.wechatpay }}" alt="{{ theme.author }} WeChat Pay"/>
          <p>微信打赏</p>
        </div>
      {% endif %}
      {% if theme.alipay %}
        <div id="alipay" style="display: inline-block">
          <img id="alipay_qr" src="{{ theme.alipay }}" alt="{{ theme.author }} Alipay"/>
          <p>支付宝打赏</p>
        </div>
      {% endif %}
    </div>
  </div>
{% endif %}
