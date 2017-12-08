#include<iostream>
#include<fstream>
#include<string>
#include<vector>

using namespace std;

struct loc {
	string chrom;
	int start;
	int end;
	string var;
};

void returnCluster(vector<loc> & vl);//returns the cluster indices
void findStr(string & str, char c, size_t & count, vector<size_t> & vpos);
vector<string> splitField(string & str,char c);//split the contents of a field that are delimited by a char.
bool comparElem(vector<string> & vs, char s);

int main(int argc,char *argv[])
{
	if(argc<2)
	{
		cerr<<"usage:varsplit foo.txt"<<endl;
		exit(EXIT_FAILURE);
	}
	vector<loc> vl; 
	loc temploc;
	string str,count, refChrom, refStart,refEnd,strain,var,len,start,end,dspr,dsprStart,dsprEnd;//strain holds strain names,var holds variant types, and len holds variant lengths
	vector<string> vrefChrom,vrefStart,vrefEnd,vstrain,vvar,vstart,vend,vdspr;
	ifstream fin;
	size_t spos = 0;
	vector<size_t> vpos;
	vector<string> vstr;
	bool varFlag;
	fin.open(argv[1]);
	while(getline(fin,str))
	{
		findStr(str,'\t',spos,vpos);
		count = str.substr(vpos[2]+1,vpos[3]-vpos[2]-1); //count field
		
		refChrom = str.substr(vpos[3]+1,vpos[4]-vpos[3]-1);//strain field
		vrefChrom = splitField(refChrom,';');
		
		refStart = str.substr(vpos[4]+1,vpos[5]-vpos[4]-1);//start field
		vrefStart = splitField(refStart,';');

		refEnd = str.substr(vpos[5]+1,vpos[6]-vpos[5]-1);//end field
		vrefEnd = splitField(refEnd,';');

		var = str.substr(vpos[6]+1,vpos[7]-vpos[6]-1);//var name field
		vvar = splitField(var,';');

		dspr = str.substr(vpos[7]+1,vpos[8]-vpos[7]-1);//strain name field
		vdspr = splitField(dspr,';');

		start = str.substr(vpos[8]+1,vpos[9]-vpos[8]-1);//strain start field
		vstart = splitField(start,';');

		end = str.substr(vpos[9]+1,vpos[10]-vpos[9]-1);//dspr strain end field
		vend =splitField(end,';');

		//cout<<vrefChrom[0]<<"\t"<<vrefStart[0]<<"\t"<<vrefEnd[0]<<endl;
		varFlag = comparElem(vvar,'c');
		//cout<<strainFlag<<"\t"<<varFlag<<"\t"<<lenFlag<<"\n";
		if(varFlag == 0) 
		{
			cout<<str<<endl;
			for(unsigned int i=0; i<vrefChrom.size();i++)
			{
				temploc.chrom = vrefChrom[i];
				temploc.start = stoi(vrefStart[i]);
				temploc.end = stoi(vrefEnd[i]);
				temploc.var = vvar[i];
				vl.push_back(temploc);
			}
	
			returnCluster(vl);		
		}
		vl.clear();	
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
void returnCluster(vector<loc> & vl)
{
	int ovl =0;
	for(unsigned int i=1;i<vl.size();i++)
	{
		cout<<"index\t"<<i<<"\t";
		ovl = min(vl[i-1].end,vl[i].end) - max(vl[i-1].start,vl[i].start); //overlap between ith and (i-1)th elements
		if((double(ovl)/double(vl[i].end - vl[i].start) >0.95) && (double(ovl)/double(vl[i-1].end - vl[i-1].start) >0.95))
		{
			cout<<i<<endl;
		} 
		
	}
}	
