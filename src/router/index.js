import Vue from 'vue'
import Router from 'vue-router'
import IdeaBoard from '@/components/IdeaBoard'
import FullVersion from '@/components/FullVersion'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'ideaBoard',
      component: IdeaBoard
    },
    {
      path: '/fullversion',
      name: 'fullversion',
      component: FullVersion
    }
  ]
})
