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

    let rescaling_factor = 0.3;

    let map_width = 2890 * rescaling_factor;
    let map_height = 1940 * rescaling_factor;

    /**
    * @param {number} slider_value
    * @param {number} month
    */
    let month;

    let slider_value = 0;

    function mapSliderToDateString(slider_value) {
    var year = Math.floor(slider_value / 12) + 2019;
    var month_number = (slider_value % 12) + 1;
    if (month_number < 10) {
        month = "0" + month_number;
    }else{
        month = month_number;
    }
    return year + "-" + month;
}

</script>

<!--<input type="range" min="201901" max="202312" bind:value={slider_value} /><br/>-->
<input type="range" min="0" max="59" step="1" bind:value={slider_value} />

<!--Prints the date that is being displayed-->
{mapSliderToDateString(slider_value)}

<br>

<!-- Button! -->
<Button />

<!--The actual plot-->
<svg width={map_width} height={map_height}>
      <image xlink:href="http://localhost:5173/faerun.jpg" width={map_width} height={map_height} opacity="0.7"/>
        {#each datapoints_vis1 as datapoint}
        {#if datapoint.year_month == mapSliderToDateString(slider_value)}
            <circle 
            cx={datapoint.Coord_X * rescaling_factor} 
            cy={datapoint.Coord_Y * rescaling_factor} 
            r= {datapoint.CartPriceInCP * (0.00008 * rescaling_factor)}
            fill-opacity = "0.4" />
        {/if}
        {/each}
  </svg>