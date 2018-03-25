<template>
  <div id="board">
    <h3>My Ideas({{myIdeas.length}})</h3>
    <ul>
      <li v-for="(idea,index) in myIdeas" :key="index">{{idea.name}}</li>
    </ul>
  </div>
</template>

<script>
  import Idea from './Idea.vue'
  import IdeaStarter from '@/js/ideaStarter'

  export default {
    name: 'ideaBoard',
    data () {
      return {
        myIdeas: [],
        ideas: []
      }
    },
    beforeCreate: function () {
      IdeaStarter.init()
      .then(response => {
        this.getIdeas();
      })
    },
    methods: {
      addIdea: function () {

      },
      getIdeas: function () {
        this.ideas = []
        this.myIdeas = []
        IdeaStarter.getIdeasCount()
        .then(count => {
          for(let i =0; i< count; i++){
            IdeaStarter.getIdea(i).then(idea=> {
              this.ideas[i] = idea;
              this.ideas = [...this.ideas] // for render
              this.myIdeas = this.ideas.filter(x=> x.owner == window.web3.eth.accounts[0])
            });
          }
        })
      }
    }
  }
</script>

<style>
  input{
    margin-right: 20px;
  }
</style>
