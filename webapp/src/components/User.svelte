<script lang="ts">
  import type { User } from "../models";
  import dateformat from "dateformat";
  import { copyTextToClipboard } from "../util";
  import Flag from "./Flag.svelte";

  export let user: User;

  function copyToClipboard(e: MouseEvent, content?: string) {
    const target = e.currentTarget as HTMLElement;
    content = content ?? target.innerText;
    copyTextToClipboard(content);
  }
</script>

<main>
  <div class="user-container">
    <div class="head">
      <img
        class="clickable"
        on:click={(e) => copyToClipboard(e, user.avatar_url)}
        src={user.avatar_url}
      />
      <div>
        <div class="username">
          <h2 class="clickable" on:click={copyToClipboard}>
            {user.username}#{user.discriminator}
          </h2>
          {#if user.bot}
            <span class="bot-tag">
              {#if user.flags_abstracted.includes("verified_bot")}<img
                  src="/assets/img/check.svg"
                />{/if}
              BOT</span
            >
          {/if}
        </div>
        <p class="embed clickable" on:click={copyToClipboard}>{user.id}</p>
        {#if user.public_flags != 0}
          <div class="flags">
            <Flag
              flags={user.flags_abstracted}
              flag="discord_employee"
              resource="staff"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="partnered_server_owner"
              resource="new_partner"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="hypesquad_events"
              resource="hypesquad"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="bughunter_level_1"
              resource="bug_hunter"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="house_bravery"
              resource="bravery"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="house_brilliance"
              resource="brilliance"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="house_balance"
              resource="balance"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="early_supporter"
              resource="early_supporter"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="bughunter_level_2"
              resource="bug_hunter"
            />
            <Flag
              flags={user.flags_abstracted}
              flag="early_cerified_developer"
              resource="verified_developer"
            />
          </div>
        {/if}
      </div>
    </div>
    <table>
      <tbody>
        <tr>
          <th>Created</th>
          <td class="clickable" on:click={copyToClipboard}
            >{dateformat(user.creation)}</td
          >
        </tr>
        <tr>
          <th>Flags</th>
          <td class="clickable" on:click={copyToClipboard}
            >{user.public_flags}</td
          >
        </tr>
        <tr>
          <th>Avatar ID</th>
          <td class="clickable" on:click={copyToClipboard}>{user.avatar}</td>
        </tr>
        <tr>
          <th>Request Count</th>
          <td class="clickable" on:click={copyToClipboard}
            >{user.request_count}</td
          >
        </tr>
      </tbody>
    </table>
    <p class="footnote">Last Fetched: {dateformat(user.date)}</p>
  </div>
</main>

<style lang="scss">
  .user-container {
    background-color: rgba(black, 0.1);
    padding: 20px;
    margin-top: 40px;
    max-width: calc(100vw - 70px);

    p,
    h2 {
      margin: 0;
    }

    > div > * {
      margin-bottom: 5px;
    }

    > div {
      width: 100%;
      overflow: hidden;
    }

    table {
      max-width: 100%;
      margin-top: 10px;
      word-wrap: break-word;
      th {
        padding-right: 10px;
        text-transform: uppercase;
        font-weight: normal;
        font-size: 0.7em;
        opacity: 0.8;
        text-align: left;
      }
      td {
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }

    .head {
      display: flex;
      align-items: center;

      > img {
        border-radius: 100%;
        margin-right: 20px;
        width: 20vw;
        height: 20vw;
        max-width: 80px;
        max-height: 80px;
      }

      .username {
        display: flex;
        align-items: center;

        .bot-tag {
          display: flex;
          background-color: #7d35f2;
          font-size: 12px;
          font-weight: normal;
          padding: 2px 5px;
          margin-left: 10px;
          color: white;
          > img {
            height: 1.3em;
            margin-right: 5px;
          }
        }
      }
    }

    .embed {
      font-family: monospace;
      background-color: rgba(black, 0.25);
      width: fit-content;
      padding: 2px 5px;
    }

    .footnote {
      margin-top: 15px;
      font-size: 10px;
      opacity: 0.6;
    }

    .flags {
      display: flex;
      margin-top: 10px;
    }

    .clickable {
      cursor: pointer;
      position: relative;

      &::after {
        content: "";
        background-image: url("/assets/img/clipboard.svg");
        background-repeat: no-repeat;
        background-size: 80%;
        background-position: center;
        color: white;
        height: 20px;
        width: 20px;
        position: absolute;
        white-space: nowrap;
        background-color: #5c6bc0;
        transform: translateX(10px);
        pointer-events: none;
        opacity: 0;
        transition: all 0.2s ease;
        box-shadow: 0px 3px 10px 0px rgba(black, 0.5);
      }

      &:hover::after {
        opacity: 1;
      }
    }
  }
</style>
