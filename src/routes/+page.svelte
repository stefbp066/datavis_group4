<!-- <h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>
-->
<script>
    let datapoints = []
    fetch('http://localhost:5173/vis1_coordinate.json')
      .then(res => res.json())
      .then(data => datapoints = data)

    let rescaling_factor = 0.6;

    let map_width = 2890 * rescaling_factor;
    let map_height = 1940 * rescaling_factor;

  </script>
  
  <svg width={map_width} height={map_height}>
      <image xlink:href="http://localhost:5173/faerun.jpg" width={map_width} height={map_height} opacity="0.7"/>
        {#each datapoints as datapoint}
        {#if datapoint.year_month == "2019-03"}
            <circle cx={datapoint.Coord_X * rescaling_factor} cy={datapoint.Coord_Y * rescaling_factor} r= {10 * (rescaling_factor + .1)} />
        {/if}
        {/each}
    </svg>