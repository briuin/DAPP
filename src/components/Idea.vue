<template>
  <div class="idea-container">
    <div class="idea-name"><strong>{{idea.name}}</strong></div>
    <div class="idea-deascription"><i><small>{{idea.description}}</small></i></div>
    <div><div class="idea-title">Owner</div>: <small style="color: blue;">{{owner}}</small></div>
    <div><div class="idea-title">Goal</div>: {{idea.goal}} ETH</div>
    <div><div class="idea-title">Funded</div>: {{idea.funded}} ETH</div>
    <div><div class="idea-title">Backers</div>: {{idea.backersCount}}</div>
    <div v-if="idea.url">Website: <a :href="idea.url" target="_blank">Click for details</a></div>
    <div class="idea-back" v-if="!isOwner">Amount (ETH): <input v-model="backAmount" style="width:50px;"/>
      <button @click="backIdea(idea.id, idea.owner)">Back this idea</button>
    </div>
  </div>
</template>

<script>
  import IdeaStarter from '@/js/ideaStarter'

  export default {
    name: 'idea',
    props: ['idea', 'contractOwner'],
    data: function(){
      return({
        backAmount: 1
      })
    },
    computed: {
      owner: function (){
        return this.idea.owner == window.web3.eth.accounts[0] ? "You" : this.idea.owner;
      },
      isOwner: function () {
        return this.idea.owner == window.web3.eth.accounts[0]
      },
      isContractOwner: function () {
        return this.contractOwner == window.web3.eth.accounts[0]
      }
    },
    methods: {
      backIdea: function(id, owner) {
        IdeaStarter.backIdea(id, owner, this.backAmount)
        .then(response => {
          window.location.reload();
        })
      }
    }
  }

</script>

<style scoped>
  .idea-container {
    width: 290px;
    border: 2px solid black;
    border-radius: 10px;
    display: inline-block;
    margin-right: 3px;
    padding: 10px;
    margin-bottom: 20px;
    height: 250px;
    #text-align: center;
    background-color: rgb(250,250,250);
  }

  .idea-title {
    width:70px;
    display:inline-block;
  }

  .idea-back {
    margin-top: 15px;
  }

  .idea-name {

  }

  .idea-deascription{
    color: grey;
  }
</style>
