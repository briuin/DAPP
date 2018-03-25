<template>
  <div id="board">
    <div>
      <template v-if="isOwner">
        <h3>Token Address( Only for Owner )</h3>
        Address: <input v-model="tokenAddress"/>
        <button @click="setTokenAddress">Set</button>
      </template>
      <template>
        <h3>Add Idea</h3>
        Name: <input v-model="ideaName"/>
        Description: <input v-model="ideaDescription" style="width:200px;"/>
        Website: <input v-model="ideaUrl" style="width:80px"/>
        Lucky Number: <input v-model.number="ideaLuckyNumber" style="width:30px"/>
        <button @click="addIdea">Add Idea</button>
      </template>
    </div>
    <hr/>
    <Idea v-for="idea in ideas" :idea="idea" :contractOwner="owner"></Idea>
    <hr/>
    <h3>Token Holders</h3>
    <div>
      <table>
        <tr>
          <th>No.</th>
          <th>Address</th>
          <th>Amount</th>
        </tr>
        <tr v-for="(holder,index) in sortedTokenHolders">
          <td>{{index +1}}</td>
          <td>{{holder.address}}</td>
          <td>{{toNum(holder.amount)}}</td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
  import Idea from './Idea.vue'
  import IdeaStarter from '@/js/ideaStarterFullVersion'

  export default {
    name: 'fullVersion',
    components: {
      Idea
    },
    data () {
      return {
        tokenAddress: "0x0",
        ideaName: "",
        ideaDescription: "",
        ideaUrl: "",
        ideaLuckyNumber: 0,
        ideas: [],
        tokenHolders: [],
        sortedTokenHolders: [],
        owner: ""
      }
    },
    computed: {
      isOwner: function() {
        return this.owner == window.web3.eth.accounts[0];
      }
    },
    beforeCreate: function () {
      IdeaStarter.init()
      .then(response => {
        this.getIdeas();
        this.getTokenHolders();
        this.getOwner();
      })
    },
    methods: {
      toNum: function(n) {
         var nStr = (n + "");
         if(nStr.indexOf(".") > -1)
            nStr = nStr.replace(".","").replace(/\d+$/, function(m){ return --m; });
         return nStr.replace(/(\d+)e\+?(\d+)/, function(m, g1, g2){
            return g1 + new Array(+g2).join("0") + "0";
         })
      },
      addIdea: function () {
        IdeaStarter.addIdea(this.ideaName, this.ideaDescription, this.ideaLuckyNumber, this.ideaUrl)
        .then(receipt=>{
          this.getIdeas();
          this.getTokenHolders();
        })
      },
      getIdeas: function () {
        this.ideas = []
        IdeaStarter.getIdeasCount()
        .then(count => {
          for(let i =0; i< count; i++){
            IdeaStarter.getIdea(i).then(idea=> {
              this.ideas[i] = idea;
              this.ideas = [...this.ideas] // for render
            });
          }
        })
      },
      getTokenHolders: function () {
        this.tokenHolders = []
        IdeaStarter.getTokenHolderCount()
        .then(count => {
          for(let i =0; i< count; i++){
            IdeaStarter.getTokenBalanceByIndex(i).then(holder=> {
              this.tokenHolders[i] = holder;
              this.tokenHolders = [...this.tokenHolders] // for render
              this.sortedTokenHolders = [...this.tokenHolders].sort((x,y)=>{return y.amount-x.amount});
            });
          }
        })
      },
      setTokenAddress: function () {
        if(this.tokenAddress != "0x0"){
          IdeaStarter.setTokenAddress(this.tokenAddress);
        }
      },
      getOwner: function () {
        IdeaStarter.getOwner()
        .then(owner => {
          this.owner = owner;
        });
      }
    }
  }
</script>

<style>
  input{
    margin-right: 20px;
  }

  table{
		width: 95%;
		margin: 10px auto;
		border-collapse: collapse;
	}
	tr th, tr td{
		width: 15%;
		text-align: center;
		border-bottom: 1px solid #b9b9b9;
		padding-bottom: 8px;
		padding-top: 8px;
	}
	tr td{
		font-size: 16px;
	}
</style>
