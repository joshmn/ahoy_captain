import { Controller } from '@hotwired/stimulus';
import 'chartjs-plugin-datalabels';
import { getCSS, externalTooltipHandler } from "helpers/chart_utils";

const calculatePercentageDifference = function(oldValue, newValue) {
  if(!oldValue) { return false }
  if (oldValue == 0 && newValue > 0) {
    return 100
  } else if (oldValue == 0 && newValue == 0) {
    return 0
  } else {
    return Math.round((newValue - oldValue) / oldValue * 100)
  }
}

export default class extends Controller {
  connect() {
    this.funnel = JSON.parse(this.element.dataset.data);

    const fontFamily = 'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"';
    const labels = this.funnel.steps.map((step) => step.name);
    const stepData = this.funnel.steps.map((step) => step.total_events);
    const dropOffData = this.funnel.steps.map((step) => step.drop_off * 100);

    const data = {
      labels,
      datasets: [
        {
          label: 'Visitors',
          data: stepData,
          borderRadius: 4,
          color: getCSS('--ac'),
          backgroundColor: getCSS('--p'),
          stack: 'Stack 0',
          yAxisID: 'y',
        },
        {
          label: 'Dropoff',
          data: dropOffData,
          borderRadius: 4,
          stack: 'Stack 0',
          color: getCSS('--ac'),
          backgroundColor: getCSS('--a'),
          yAxisID: 'yComparison',
        },
      ],
    };

    const config = {
      responsive: true,
      maintainAspectRatio: false,
      plugins: [ChartDataLabels],
      type: 'bar',
      data,
      options: {
        layout: {
          padding: 100,
        },
        plugins: {
          legend: false,
          tooltip: {
            enabled: false,
            position: 'nearest',
            external: externalTooltipHandler(this)
          },
          datalabels: {
            anchor: 'end',
            align: 'end',
            borderRadius: 4,
            padding: {
              top: 8, bottom: 8, right: 8, left: 8,
            },
            color: getCSS('--pc'),
            textAlign: 'center',
          },
        },
        scales: {
          y: { display: false },
          x: {
            position: 'bottom',
            display: true,
            border: { display: false },
            grid: { drawBorder: false, display: false },
            ticks: {
              padding: 8,
            },
          },
        },
      },
    };

    const visitorsData = [];

    this.chart = new Chart(
      this.element,
      config,
    );
  }

  formatLabel(label) {
    return label
  }

  formatMetric(metric) {
    return metric
  }


  extractTooltipData(tooltip) {
    const data = this.funnel.steps.find(step => step.name === tooltip.title[0]);

    const value = data.total_events;
    const label = "Visitors"
    let comparisonLabel = "Dropoff"
    let comparisonValue =  data.unique_visits;

    return {
      comparison: true,
      comparisonDifference: false,
      metric: tooltip.title[0],
      label: this.formatLabel(label),
      labelBackgroundColor: getCSS('--bc'),
      formattedValue: value,
      comparisonLabel: comparisonLabel,
      comparisonLabelBackgroundColor: "",
      formattedComparisonValue: comparisonValue,
    }
  }
}
