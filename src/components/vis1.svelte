<style>
    .plot {
        top: 50%;
        left: 50%;
    }

        .circle:hover {
            fill-opacity : 0.6;
            content: attr(data-tooltip); /* Set tooltip content */
        }
        
        .outside-text {
            position: absolute;
            top: 0px; /* Adjust top position */
            left: 0px; /* Adjust left position */
        }

        svg text {
            display: none; /* Hide all text elements by default */
        }

        svg g:hover text {
            display: block; /* Display text elements when circle is hovered over*/
        }

</style>

<script>
    import data_vis1 from '../data/vis1_coordinate.json';
    
    import Button from './Button.svelte';   

    let datapoints_vis1 = data_vis1.map(d => {
      return {
        ...d,
        Coord_X : Number(d.Coord_X),
        Coord_Y : Number(d.Coord_Y),
        CartPriceInCP : Number(d.CartPriceInCP),
        year_month : d.year_month.toString()
      }
    });

    let rescaling_factor = 0.25;

    let map_width = 2890 * rescaling_factor;
    let map_height = 1940 * rescaling_factor;

    /**
    * @param {number} month
    */

    let month; // initialize variable month

    let slider_value = 0;  //initialize slider_value (will start at 2019-01)

    /**
    *@param {number} slider_value
    */

    function mapSliderToDateString(slider_value) {
    var year = Math.floor(slider_value / 12) + 2019;
    var month_number = (slider_value % 12) + 1;
    if (month_number < 10) {
        month = "0" + month_number;
    }else{
        month = month_number;
    }
    return year + "-" + month};

    function play_animation() {
    for (let i = 0; i < 60; i++) {
        setTimeout(() => {
            slider_value = i;
        }, i * 500); // Wait 500 iterations, then update slider_value
    }

}

</script>

<body>

<h1 style="position: absolute; top: 5px; left: 10px;"> Visualization 1 </h1>

<!--<input type="range" min="201901" max="202312" bind:value={slider_value} /><br/>-->
<div style="position: absolute; top: 90%; left: 30%; white-space: nowrap">
    <input style="position: absolute; top: 0px; left: 60px;" type="range" min="0" max="59" step="1" bind:value={slider_value} />
    <p style="position: absolute; top: -17px; left: 240px; margin-top: 20px;">Date: {mapSliderToDateString(slider_value)} </p>
    <Button style="position: absolute; top: 0px; left: 0; margin-top: 20px;" on:click={play_animation}>
        Play
    </Button>
</div>


<!--The actual plot-->
<svg class = "plot" width={map_width} height={map_height}>
      <image xlink:href="http://localhost:5173/faerun.jpg" width={map_width} height={map_height} opacity="0.7"/>
        {#each datapoints_vis1 as datapoint}
        {#if datapoint.year_month == mapSliderToDateString(slider_value)}
            <g>
            <circle class="circle"
            data-tooltip="test"
            cx={datapoint.Coord_X * rescaling_factor} 
            cy={datapoint.Coord_Y * rescaling_factor} 
            r= {datapoint.CartPriceInCP * (0.00008 * rescaling_factor)}
            fill-opacity = "0.4"
            fill = #4D4D4D 
            />
            <text class = "outside-text" x="50" y="50">{datapoint.Nation}</text>
            </g>
        {/if}
        {/each}
  </svg>

</body>