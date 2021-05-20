<script lang="ts">
  import User from "./components/User.svelte";
  import type { User as UserModel } from "./models";

  let id = "";
  let fetchPromise: Promise<UserModel>;

  function onInput(e: Event) {
    const v = (e.currentTarget as HTMLInputElement).value;
    const match = v.match(/\d+/);
    id = match?.length > 0 ? match[0] : "";
    fetchPromise = undefined;

    setTimeout(
      (cv: string) => {
        if (id === cv) fetchPromise = fetchData();
      },
      700,
      v
    );
  }

  async function fetchData(): Promise<UserModel> {
    const res = await window.fetch("http://localhost:8080/lookup/" + id);
    const body = await res.json();
    if (res.ok) {
      return body;
    } else {
      throw body;
    }
  }
</script>

<main>
  <div class="container">
    <h1>LOOKUP<span class="heading-clr">EX</span></h1>
    <input autofocus bind:value={id} on:input={(v) => onInput(v)} />
    {#if id && fetchPromise}
      {#await fetchPromise}
        <p>Loading ...</p>
      {:then user}
        <User {user} />
      {:catch err}
        <div class="error-container">
          <span>Error: {err?.message ?? err?.user_id[0] ?? "unknown"}</span>
        </div>
      {/await}
    {/if}
  </div>
</main>

<style lang="scss">
  h1 {
    font-size: 40px;
  }

  input {
    padding: 5px 10px;
    color: #ffffff;
    background-color: rgba(black, 0.2);
    border: none;
    outline: none;
    font-size: 16px;
    transition: all 0.2s ease;
    border-bottom: solid 0px #7d35f2;
    width: 90vw;
    max-width: 250px;
    text-align: center;

    &:focus {
      border-width: 5px;
    }
  }

  .container {
    display: flex;
    flex-flow: column;
    align-items: center;
    margin-top: 8vh;
  }

  .error-container {
    background-color: #f44336;
    padding: 5px 10px;
    margin-top: 30px;
  }

  .heading-clr {
    color: #7d35f2;
  }
</style>
