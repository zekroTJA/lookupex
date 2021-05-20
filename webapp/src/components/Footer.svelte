<main>
  <div class="footer">
    <span>© 2021 zekro</span>
    <span class="spacer" />
    <a href="https://github.com/zekroTJA/lookupex">GitHub</a>
    <span class="spacer" />
    <a href="https://zekro.de/imprint">Imprint</a>
    <span class="spacer" />
    <a href="https://ko-fi.com/zekro">Buy me a Coffee&nbsp;☕️</a>
  </div>
</main>

<style lang="scss">
  .footer {
    position: fixed;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0px 0px 10px 0px;
    width: 100%;
    font-size: 12px;
    opacity: 0.75;
    transition: all 0.2s ease;
    cursor: default;

    &:hover {
      opacity: 1;
    }

    .spacer {
      height: 10px;
      width: 1px;
      background-color: rgb(150, 150, 150);
      margin: 0 10px;
    }

    > span {
      color: rgb(190, 190, 190);
    }
  }
</style>
