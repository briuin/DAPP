import Vue from 'vue'
import IdeaBoard from '@/components/IdeaBoard'
import router from '@/router'

describe('IdeaBoard.vue', () => {
  it('should render correct contents', () => {
    const Constructor = Vue.extend(IdeaBoard)
    const vm = new Constructor({router}).$mount()
    expect(vm.$el.querySelector('h3').textContent)
      .to.match(/(?:Ideas)/)
  })
})
