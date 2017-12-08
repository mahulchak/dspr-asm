#include<iostream>
#include<fstream>
#include<string>
#include<vector>

using namespace std;

void findStr(string & str, char c, size_t & count, vector<size_t> & vpos);
vector<string> splitField(string & str,char c);//split the contents of a field that are delimited by a char.
bool comparElem(vector<string> & vs, char s);
bool checkHalves(vector<string> &vs, char s); 
int main()
{
	string str,count,strain,var,len,start,end,dspr,dsprStart,dsprEnd;//strain holds strain names,var holds variant types, and len holds variant lengths
	ifstream fin;
	size_t spos = 0;
	vector<size_t> vpos;
	vector<string> vstr;
	bool strainFlag = 0,varFlag = 0,lenFlag = 0, startFlag =0, dsprFlag =0;
	//fin.open("master_table_d10_doubleton.txt");
	//fin.open("master_table_d10_no_doubleton.txt");
	fin.open("master_table_d10_after_filter2.txt");
	while(getline(fin,str))
	{
		findStr(str,'\t',spos,vpos);
		count = str.substr(vpos[2]+1,vpos[3]-vpos[2]-1); //count field
		strain = str.substr(vpos[3]+1,vpos[4]-vpos[3]-1);//strain field
		start = str.substr(vpos[4]+1,vpos[5]-vpos[4]-1);//start field
		var = str.substr(vpos[6]+1,vpos[7]-vpos[6]-1);//var name field
		len = str.substr(vpos[11]+1,vpos[12]-vpos[11]-1);//length field
		dspr = str.substr(vpos[7]+1,vpos[8]-vpos[7]-1);//strain name field

		//cout<<strain<<"\t"<<var<<"\t"<<len<<endl;
		vstr = splitField(strain,';');
		strainFlag = comparElem(vstr,'c');
		vstr = splitField(var,';');
		//checkHalves(vstr,'c');
		varFlag = comparElem(vstr,'c');
		vstr = splitField(len,';');
		lenFlag = comparElem(vstr,'i');
		vstr = splitField(start,';');
		startFlag = comparElem(vstr,'i');
		//cout<<strainFlag<<"\t"<<varFlag<<"\t"<<lenFlag<<"\n";
		if((varFlag == 0) && (lenFlag == 0))
		{
	//		cout<<str<<endl;
		}
	//	else if((startFlag == 0) && (varFlag == 0))
	//	{
	//		cout<<str<<endl;
	//	}
		else
		{
			//cout<<str<<endl;
			vstr = splitField(dspr,';');
			if(stoi(count) == 2) //if only 2 elements are present
			{
				dsprFlag = checkHalves(vstr,'c');//if both strain names in the strain field are same
				if(dsprFlag ==0)
				{
			//		cout<<str<<endl;
				}
				else
				{
					cout<<str<<endl;
				}
			}
				
			vstr = splitField(var,';');
			dsprFlag = checkHalves(vstr,'c');
			if(stoi(count)>2)
			{
				if((dsprFlag == 0) && (varFlag != 0))
				{
	//				cout<<str<<endl;
				}
				else
				{
					cout<<str<<endl;
				}
			}
		}
		vpos.clear();
		
	}
	fin.close();

	return 0;
}
////////////////////////////////////////////////////////////////////////
void findStr(string & str, char c, size_t & count, vector<size_t> & vpos)
{
	size_t pos;
	pos = str.find(c,count+1);
	vpos.push_back(pos);
	if(pos < str.size())
	{
		//cout<<pos<<'\t';
		findStr(str,c,pos,vpos);
	}
}
///////////////////////////////////////////////////////////////////////
vector<string> splitField(string & str, char c)
{
	size_t pos =1, pos1 =0;
	vector<string> vs;
	string tempstr;
	while(pos1 <str.size())
	{
		pos1 = str.find(c,pos);
		if(pos1 < str.size())
		{
			tempstr = str.substr(pos-1,pos1-pos+1);
			if(tempstr[0] == ';')
			{
				tempstr = tempstr.substr(1); //remove the preceding delimiter
			}
			pos = pos1+1;
			//cout<<tempstr<<"\t";
			vs.push_back(tempstr);
		}
		
	}
	tempstr = str.substr(pos);
	vs.push_back(tempstr);
	//cout<<tempstr<<endl;
	
	return vs;
}
//////////////////////////////////////////////////////////////////////////
bool comparElem(vector<string> & vs, char s)
{
	bool diff = false;
	for(unsigned int i= 1; i<vs.size();i++)
	{
		if(s == 'c') //if s is char
		{
			if(vs[i] != vs[i-1])
			{
				diff = true;
				break;
			}
		}
		if(s == 'i')
		{
			if(stoi(vs[i],nullptr) != stoi(vs[i-1],nullptr))
			{
				diff = true;
				break;
			}
		}
	}
	return diff;
}	
///////////////////////////////////////////////////////////////////////////
bool checkHalves(vector<string> &vs, char s) //checks if elements in a field are symmetrical e.g. CNV:CNV:INS:INS
{
	bool diff = true;
	int size = 0;
	vector<string> nvs1,nvs2; //two vectors to hold the two halves of the field
	if(vs.size() % 2 == 0) //if it is equally divisible
	{
		size = int(vs.size())/2;
		if(vs.size() >2) //if the size is greater than 2 only then it works
		{
			nvs1.assign(vs.begin(),vs.begin()+size);
			nvs2.assign(vs.begin()+size,vs.end());

			if((comparElem(nvs1,'c') == 0) && (comparElem(nvs2,'c') == 0)) //all elements are identical
			{
				diff =false;
			}			
		}
		if(vs.size() == 2)
		{
			if(vs[0] == vs[1])
			{
				diff = false;
			}
		}
//		cout<<"\n"<<size<<"\n";
		return diff;
	}
	else	
	{
		return diff;
	}
}	
