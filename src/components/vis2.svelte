<script>
    import { min, max } from 'd3';
    
    import data_vis3 from '../data/monthlyrevenue.json';

    let datapoints_vis3 = data_vis3.map(d => {
      return {
        ...d,
        order : d.OrderYear.toString() + getMonthName(d.OrderMonth.toString()),
        OrderYear : Number(d.OrderYear),
        Revenue : Number(d.Revenue)
      }
    }); 


    /**
     * @param {string} month_number
     */
    
     function getMonthName(month_number){
      if (month_number.length === 1) {
        return "0" + month_number
      }
      else {
        return month_number
      }
    };

    const rescale = function(/** @type {number} */ x, /** @type {number} */ domain_min, /** @type {number} */ domain_max, /** @type {number} */ range_min, /** @type {number} */ range_max) {
      return ((range_max - range_min)*(x-domain_min))/(domain_max-domain_min) + range_min
    }
    
    // THIS IS FOR VIS 3
    let rescaling_factor = 0.3;

    let margin = { top: 20, right: 20, bottom: 30, left: 40 };

    let max_revenue = max(datapoints_vis3, d => d.Revenue);
    let min_revenue = min(datapoints_vis3, d => d.Revenue);
    let max_year = max(datapoints_vis3, d => d.OrderYear);

    let vis3_width = 2890 * rescaling_factor;
    let vis3_height = 1940 * rescaling_factor;


</script>