<script lang="ts">
  export let flags: string[];
  export let flag: string;
  export let resource: string;
</script>

<main>
  {#if flags?.includes(flag)}
    <img
      alt={flag}
      src={`/assets/img/badges/${resource}_badge.png`}
      width="24"
      height="24"
      style="margin-right: 5px"
    />
  {/if}
</main>
