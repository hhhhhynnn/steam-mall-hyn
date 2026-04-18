<template>
  <router-view />
</template>

<script setup>
</script>

<style>
:root {
  --steam-bg: #1b2838;
  --steam-surface: #16202d;
  --steam-panel: #1f2f45;
  --steam-panel-soft: rgba(34, 58, 84, 0.75);
  --steam-text: #c7d5e0;
  --steam-muted: #8f98a0;
  --steam-link: #66c0f4;
  --steam-link-hover: #ffffff;
  --steam-accent: #5ba32b;
  --steam-accent-hover: #79c749;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: "Motiva Sans", "Microsoft YaHei", Arial, sans-serif;
  background:
    radial-gradient(1200px 400px at 30% -10%, #294b6b 0%, rgba(41, 75, 107, 0) 60%),
    linear-gradient(180deg, #1b2838 0%, #101822 100%);
  color: var(--steam-text);
}

#app {
  min-height: 100vh;
}

a {
  color: var(--steam-link);
  text-decoration: none;
}

a:hover {
  color: var(--steam-link-hover);
}
</style>
