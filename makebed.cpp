#include<iostream>
#include<fstream>
#include<string>
#include<vector>

using namespace std;

void findStr(string & str, char c, size_t & count, vector<size_t> & vpos);
vector<string> splitField(string & str,char c);//split the contents of a field that are delimited by a char.
int main(int argc, char *argv[])
{
	if(argc<1)
	{
		cerr<<"Usage: makebed foo.txt"<<endl;
		exit(EXIT_FAILURE);
	}
	string str,refName,refStart,refEnd,train,start,end,dspr,dsprStart,dsprEnd;//strain holds strain names,var holds variant types, and len holds variant lengths
	ifstream fin;
	size_t spos = 0;
	vector<size_t> vpos;
	vector<string> dsprName,svStart,svEnd;
	int st =0,en =0;
	//fin.open("master_table_d10_after_filter2.txt");
	fin.open(argv[1]);
	while(getline(fin,str))
	{
		findStr(str,'\t',spos,vpos);
		refName = str.substr(0,vpos[0]);//ref name field	
		refStart = str.substr(vpos[0]+1,vpos[1]-vpos[0]-1);//reference master start
		refEnd = str.substr(vpos[1]+1,vpos[2]-vpos[1]-1);//reference master end
		start = str.substr(vpos[4]+1,vpos[5]-vpos[4]-1);//start field
		dspr = str.substr(vpos[7]+1,vpos[8]-vpos[7]-1);//DSPR strain name field
		dsprStart = str.substr(vpos[8]+1,vpos[9]-vpos[8]-1);//DSPR start field
		dsprEnd = str.substr(vpos[9]+1,vpos[10]-vpos[9]-1);//DSPR end field

		cout<<refName<<"\t"<<refStart<<"\t"<<refEnd<<endl;
		dsprName = splitField(dspr,';');
		svStart = splitField(dsprStart,';');
		svEnd = splitField(dsprEnd,';');
		//cout<<dspr<<"\t"<<dsprStart<<"\t"<<dsprEnd<<end;	
		for(unsigned int i= 0;i<dsprName.size();i++)
		{
			st = stoi(svStart[i]);
			en = stoi(svEnd[i]);
			cout<<dsprName[i]<<"\t"<<min(st,en)-100<<"\t"<<max(st,en)+100<<endl;
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

