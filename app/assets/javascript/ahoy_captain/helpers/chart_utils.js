import { numberFormatter, durationFormatter, percentageFormatter } from "helpers/number_formatters";

export const getCSS = (varname, alpha = 1) => {
  const value = getComputedStyle(document.documentElement).getPropertyValue(varname);
  if(value.includes("em") || value.includes("px")) {
    return value
  }
  return `hsl(${getComputedStyle(document.documentElement).getPropertyValue(varname)} / ${alpha})`
}

const buildTooltipData = (controller, tooltip) => {
  return controller.extractTooltipData(tooltip)
}

export const metricFormatter = {
  "ActiveSupport::Duration": durationFormatter,
  "BigDecimal": numberFormatter,
  "Float": percentageFormatter,
  "Integer": numberFormatter
}

export const dateFormatter = {
  month: (value, type = 'short') => {
    if(type === 'short') {
      return new Date(value).toLocaleString(
        'en-US',
        { month: 'short', day: 'numeric', hour: 'numeric' }
      )
    } else {
      return new Date(value).toLocaleString(
        'en-US',
        { year: "numeric", month: 'short', day: 'numeric', hour: 'numeric' }
      )
    }
  },
  week: (value, type = 'short') => {
    return new Date(value).toLocaleString(
      'en-US',
      { month: 'short', day: 'numeric', hour: 'numeric' }
    )
  },
  day: (value, type = 'short') => {
    return new Date(value).toLocaleString(
      'en-US',
      { month: 'short', day: 'numeric', hour: 'numeric' }
    )
  },
  hour: (value, type = 'short') => {
    if(type == 'long') {
      return new Date(value).toLocaleString(
        'en-US',
        { year: 'numeric', hour: 'numeric' }
      )
    } else {
      return new Date(value).toLocaleString(
        'en-US',
        { hour: 'numeric' }
      )
    }
  },
  minute: (value, type = 'short') => {
    if(type == 'short') {
      return new Date(value).toLocaleString(
        'en-US',
        { minute: 'numeric', hour: 'numeric' }
      )
    } else {
      return new Date(value).toLocaleString(
        'en-US',
        { year: 'numeric', minute: 'numeric', hour: 'numeric' }
      )
    }
  },
}

export const externalTooltipHandler = (controller) => {

  return ({chart, tooltip}) => {
    const offset = controller.chart.canvas.getBoundingClientRect()
    let tooltipEl = document.getElementById('chartjs-tooltip')

    if (!tooltipEl) {
      tooltipEl = document.createElement('div')
      tooltipEl.id = 'chartjs-tooltip'
      tooltipEl.style.background = getCSS('--n', );
      tooltipEl.style.borderRadius = getCSS('--rounded-btn');
      tooltipEl.style.opacity = 1;
      tooltipEl.style.pointerEvents = 'none';
      tooltipEl.style.position = 'absolute';
      tooltipEl.style.transform = 'translate(-50%, 50%)';
      tooltipEl.style.transition = 'all .1s ease';
      tooltipEl.style.minWidth = '250px'

      chart.canvas.parentNode.appendChild(tooltipEl);
    }

    if (tooltipEl && offset && window.innerWidth < 768) {
      tooltipEl.style.top = offset.y + offset.height + window.scrollY + 15 + 'px'
      tooltipEl.style.left = offset.x + 'px'
      tooltipEl.style.right = null
      tooltipEl.style.opacity = 1
    }

    if (tooltip.opacity === 0) {
      tooltipEl.style.display = 'none'
      return
    }

    if (tooltip.body) {
      const tooltipData = buildTooltipData(controller, tooltip)

      tooltipEl.innerHTML = `
        <aside class="flex flex-col text-neutral-content">
          <div class="flex justify-between items-center">
            <span class="text-sm font-bold uppercase whitespace-nowrap flex mr-4">${tooltipData.metric}</span>
            ${tooltipData.comparison && tooltipData.comparisonDifference ?
        `<div class="inline-flex items-center space-x-1">
              ${tooltipData.comparisonDifference > 0 ? `<span class="font-semibold text-sm text-green-500">&uarr;</span><span>${tooltipData.comparisonDifference}%</span>` : ""}
              ${tooltipData.comparisonDifference < 0 ? `<span class="font-semibold text-sm text-red-400">&darr;</span><span>${tooltipData.comparisonDifference * -1}%</span>` : ""}
              ${tooltipData.comparisonDifference == 0 ? `<span class="font-semibold text-sm">〰 0%</span>` : ""}
            </div>` : ''}
          </div>

          ${tooltipData.label ?
        `<div class="flex flex-col">
            <div class="flex flex-row justify-between items-center">
              <span class="badge relative badge-xs" style="background-color: ${tooltipData.labelBackgroundColor}"></span>
              <span class="flex items-center grow ml-4 mr-4">
                <span>${tooltipData.label}</span>
              </span>
              <span class="font-bold">${tooltipData.formattedValue}</span>
            </div>` : ''}

            ${tooltipData.comparison ?
        `<div class="flex flex-row justify-between items-center">
              <span class="badge relative badge-xs" style="background-color: ${tooltipData.comparisonLabelBackgroundColor}"></span>
              <span class="flex items-center grow ml-4 mr-4">
                <span>${tooltipData.comparisonLabel}</span>
              </span>
              <span class="font-bold">${tooltipData.formattedComparisonValue}</span>
            </div>` : ""}
          </div>
        </aside>
      `
    }
    const {offsetLeft: positionX, offsetTop: positionY} = chart.canvas;

    // Display, position, and set styles for font
    tooltipEl.style.opacity = 1;
    tooltipEl.style.display = null;
    tooltipEl.style.left = positionX + tooltip._eventPosition.x + 'px';
    tooltipEl.style.top = positionY + tooltip._eventPosition.y + 'px';
    tooltipEl.style.font = tooltip.options.bodyFont.string;
    tooltipEl.style.padding = tooltip.options.padding + 'px ' + tooltip.options.padding + 'px';
  }
};
