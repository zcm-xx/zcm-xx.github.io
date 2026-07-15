{% if page.comments !== false %}
  {% if theme.giscus and theme.giscus.enable and theme.giscus.repo_id and theme.giscus.category_id %}
    <div class="comments" id="comments">
      <script src="https://giscus.app/client.js"
        data-repo="{{ theme.giscus.repo }}"
        data-repo-id="{{ theme.giscus.repo_id }}"
        data-category="{{ theme.giscus.category }}"
        data-category-id="{{ theme.giscus.category_id }}"
        data-mapping="{{ theme.giscus.mapping | default('pathname') }}"
        data-strict="{{ theme.giscus.strict | default('0') }}"
        data-reactions-enabled="{{ theme.giscus.reactions_enabled | default('1') }}"
        data-emit-metadata="{{ theme.giscus.emit_metadata | default('0') }}"
        data-input-position="{{ theme.giscus.input_position | default('bottom') }}"
        data-theme="{{ theme.giscus.theme | default('preferred_color_scheme') }}"
        data-lang="{{ theme.giscus.lang | default('zh-CN') }}"
        crossorigin="anonymous"
        async>
      </script>
    </div>
  {% elif theme.giscus and theme.giscus.enable %}
    <div class="comments" id="comments">
      <p>Giscus 尚未完成配置，请前往 <a href="https://giscus.app/zh-CN" target="_blank" rel="noopener">giscus.app</a> 获取 <code>repo_id</code> 与 <code>category_id</code>，并填入 <code>themes/next/_config.yml</code>。</p>
    </div>
  {% endif %}
{% endif %}
