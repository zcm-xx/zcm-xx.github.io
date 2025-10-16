<!-- 页面 title 进入/离开 效果 -->
{% if theme.title_change %}
  <script type="text/javascript">var OriginTitile=document.title,st;document.addEventListener("visibilitychange",function(){document.hidden?(document.title="期待再次光临!",clearTimeout(st)):(document.title="(ฅ>ω<*ฅ) Thank ~ "+OriginTitile,st=setTimeout(function(){document.title=OriginTitile},4e3))})</script>
{% endif %}
