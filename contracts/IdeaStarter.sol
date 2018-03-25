pragma solidity ^0.4.18;

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract IdeaFEPToken is ERC20 {
  address[] public users;
  function getUserCount() public view returns (uint);
  function getUser(uint index) public view returns (address);
  function joinFEP() public;
  function ideaPrize(uint prize) public;
  function backersBonus(address backer) public;
}

contract Random{
    function rand() public view returns (uint256){

        uint256 lastBlockNumber = block.number - 1;
        uint256 hashVal = uint256(block.blockhash(lastBlockNumber));


        // This turns the input data into a 100-sided die
        // by dividing by ceil(2 ^ 256 / 100).
        uint256 FACTOR = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
        return uint256(uint256(hashVal) / FACTOR) + 1;
      }
}

contract IdeaOwned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    function IdeaOwned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract IdeaStarter is Random, IdeaOwned{
  struct Idea{
    uint id;
    address owner;
    string name;
    string description;
    uint luckyNumber;
    uint goal;
    uint funded;
    string url;
    address[] backers;
  }

  IdeaFEPToken private token;
  address private tokenAddress;
  address[] private ideaOwners;
  uint public totalIdeas = 0;
  mapping(address => Idea[]) public ideas;

  event AddIdeaEvent(address indexed owner, string name, string description, uint goal, string url);

  function giveToken(address user, uint prize) private {
      if(ideas[user].length == 0){
          token.joinFEP();
      }

      require(prize >=0 && prize <= 100);

      token.ideaPrize(prize);
  }

  function backIdea(uint _ideaId, address _owner) public payable{
      require(msg.value >= 1 ether);
      for(uint i =0; i< ideas[_owner].length; i++){
          if(ideas[_owner][i].id == _ideaId && ideas[_owner][i].funded < ideas[_owner][i].goal){
              ideas[_owner][i].funded += msg.value;

              bool isBackerFound = false;
              for(uint j =0;j <ideas[_owner][i].backers.length ; j++){
                  if(ideas[_owner][i].backers[j] == msg.sender){
                      isBackerFound = true;
                      break;
                  }
              }
              if(!isBackerFound){
                  ideas[_owner][i].backers.push(msg.sender);
              }
              token.ideaPrize(rand() * (ideas[_owner][i].goal / 1 ether) / 10);
              if(ideas[_owner][i].funded >= ideas[_owner][i].goal){
                  _owner.transfer(ideas[_owner][i].funded);
                  // token prize
                  for(uint backer =0;backer <ideas[_owner][i].backers.length ; backer++){
                      token.backersBonus(ideas[_owner][i].backers[backer]);
                  }
                  token.backersBonus(ideas[_owner][i].owner);
                  token.backersBonus(ideas[_owner][i].owner);
                  token.backersBonus(ideas[_owner][i].owner);
                  token.backersBonus(ideas[_owner][i].owner);
              }
          }
      }
  }

  function addIdea (string _name, string _description, uint _luckyNumber, string _url) public tokenIsReady{
    if(ideas[msg.sender].length > 5){
        uint countFunding = 0;
        for(uint i=0;i<ideas[msg.sender].length;i++){
            if(ideas[msg.sender][i].funded < ideas[msg.sender][i].goal){
                countFunding ++;
            }
        }
        if(countFunding>=5){
            return;
        }
    }

    if(ideas[msg.sender].length == 0){
      ideaOwners.push(msg.sender);
    }

    uint goal = rand() * 1 ether;
    giveToken(msg.sender, goal/ 1 ether);

    Idea memory newIdea = Idea(totalIdeas, msg.sender, _name, _description, _luckyNumber, goal, 0, _url, new address[](0));
    ideas[msg.sender].push(newIdea);
    totalIdeas++;

    if(_luckyNumber == goal / 1 ether){
        token.ideaPrize(_luckyNumber);
    }

    AddIdeaEvent(msg.sender,  _name,  _description, goal, _url);
  }

  function getIdea(uint _id) public view returns (address, string, string, uint, uint, uint, string){

      for(uint i=0; i<ideaOwners.length; i++){
          for(uint j=0; j<ideas[ideaOwners[i]].length; j++){
              if(ideas[ideaOwners[i]][j].id == _id){
                  Idea storage idea = ideas[ideaOwners[i]][j];
                  return (idea.owner, idea.name, idea.description, idea.goal, idea.funded, idea.backers.length, idea.url);
              }
          }
      }
      return (0x0, "","",0,0,0, "");
  }

  function getTokenHolderCount() public view returns (uint) {

    return token.getUserCount();
  }

  function getTokenBalanceByIndex(uint _index) public returns (address, uint){
    return (token.getUser(_index), token.balanceOf(token.getUser(_index)));
  }

  function getTokenBalance(address user) public returns (uint){
    return token.balanceOf(user);
  }

  modifier tokenIsReady {
      require(tokenAddress!=address(0));
      _;
  }

  function setTokenAddress (address _tokenAddress) public onlyOwner {
    token = IdeaFEPToken(_tokenAddress);
    tokenAddress = _tokenAddress;
  }

}
