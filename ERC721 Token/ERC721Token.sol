// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface ERC721Interface {
    function balanceOf(address _owner) external view returns(uint256);
    function ownerOf(uint256 _tokenId) external view returns(address owner);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
} 

interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns(bytes4);
}

interface ERC721Metadata {
    function name() external view returns( string memory _name);
    function symbol() external view returns(string memory _symbol);
    function tokenUIR(uint256 _tokenId) external view returns(string memory);
}
contract ERC721  {
    string  private name;
    string  private symbol;
    event Transfer(address indexed _from, address indexed _to, uint256 indexed tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping(uint256 => address) internal _ownerOf;
    mapping(address => uint256) internal _balanceOf;
    mapping(uint => address) internal _approvals;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function ownerOf(uint256 _tokenId) external view returns(address owner){
        owner = _ownerOf[_tokenId];
        require(owner != address(0), "Token doesn't exist");
    }

    function balanceOf(address _owner) external view returns(uint256) {
        require(_owner != address(0), "owner = zero address");
        return _balanceOf[_owner];
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        isApprovedForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function approve(address _approved, uint256 _tokenId) external   {
        address owner = _ownerOf[_tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "not Authorized");
        _approvals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        require(_ownerOf[_tokenId] != address(0), "Token doesn't exist");
        return _approvals[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(_from == _ownerOf[_tokenId], "from != owner");
        require(_to != address(0), "transfer to zero address");
        
        _balanceOf[_from]--;
        _balanceOf[_to]++;
        _ownerOf[_tokenId] = _to;

        delete _approvals[_tokenId];
        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint _tokenId, bytes calldata data) external  {
        transferFrom(_from, _to, _tokenId);
        require(_to.code.length == 0 || ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, data) == ERC721TokenReceiver.onERC721Received.selector, "unsafe recipent");
    }

    function _mint(address _to, uint256 _tokenId) public  {
        require(_to  != address(0), "mint to Zero address");
        require(_ownerOf[_tokenId] == address(0), "already minted");
        _balanceOf[_to]++;
        _ownerOf[_tokenId] = _to;

        emit Transfer(address(0), _to, _tokenId);
    }

    function _burn(uint256 _tokenId) public {
        address owner = _ownerOf[_tokenId];
        require(owner != address(0), "not minted");

        _balanceOf[owner] -= 1;
        delete _ownerOf[_tokenId];
        delete _approvals[_tokenId];

        emit Transfer(owner, address(0), _tokenId);
    }
    constructor (string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
    }

    function Name() external view returns( string memory ){
        return name;
    }
    function Symbol() external view returns(string memory ){
        return symbol;
    }
}



