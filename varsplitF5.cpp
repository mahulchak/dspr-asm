#include<iostream>
#include<fstream>
#include<string>
#include<vector>
#include<map>
#include<algorithm>
using namespace std;

struct loc {
	string chrom;
	int start;
	int end;
	int len;
	string var;
};

map<int,vector<int> > returnCluster(vector<loc> & vl);//returns the cluster indices
void findStr(string & str, char c, size_t & count, vector<size_t> & vpos);
vector<string> splitField(string & str,char c);//split the contents of a field that are delimited by a char.
bool comparElem(vector<string> & vs, char s);
void writeField(vector<int> & vi,vector<string> & vs);
int returnUniq(vector<string> & vs,vector<int> & vi);

int main(int argc,char *argv[])
{
	if(argc<2)
	{
		cerr<<"usage:varsplitf5 foo.txt"<<endl;
		exit(EXIT_FAILURE);
	}
	vector<loc> vl; 
	loc temploc;
	string str,count, refChrom, refStart,refEnd,strain,var,start,end,dspr,dsprStart,dsprEnd,len,id,rcov,qcov;//strain holds strain names,var holds variant types, and len holds variant lengths
	vector<string> vrefChrom,vrefStart,vrefEnd,vstrain,vvar,vstart,vend,vdspr,vid,vlen,vrcov,vqcov;
	ifstream fin;
	size_t spos = 0;
	vector<size_t> vpos;
	vector<string> vstr;
	bool varFlag;
	map<int,vector<int> > mindex;	
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
		
		id = str.substr(vpos[10]+1,vpos[11]-vpos[10]-1);//id field
		vid = splitField(id,';');
			
		len = str.substr(vpos[11]+1,vpos[12]-vpos[11]-1);//length field
		vlen = splitField(len,';');
		
		rcov = str.substr(vpos[12]+1,vpos[13]-vpos[12]-1);//rcoverage
		vrcov = splitField(rcov,';');

		qcov = str.substr(vpos[13]+1);
		vqcov = splitField(qcov,';');

		//cout<<vrefChrom[0]<<"\t"<<vrefStart[0]<<"\t"<<vrefEnd[0]<<endl;
		varFlag = comparElem(vvar,'c');
		//cout<<strainFlag<<"\t"<<varFlag<<"\t"<<lenFlag<<"\n";
		if(count != "1") 
		{
			//cout<<str<<endl;
			for(unsigned int i=0; i<vrefChrom.size();i++)
			{
				temploc.chrom = vrefChrom[i];
				temploc.start = stoi(vrefStart[i]);
				temploc.len = stoi(vlen[i]);
				if(stoi(vrefEnd[i])-stoi(vrefStart[i]) == 0) //if it is a INS i.e. interval length is 0
				{
					temploc.end = stoi(vrefEnd[i])+10;
				}
				else
				{
					temploc.end = stoi(vrefEnd[i]);
				}
				temploc.var = vvar[i];
				vl.push_back(temploc);
			}
	
			mindex = returnCluster(vl);		
			for(map<int,vector<int> >::iterator it= mindex.begin();it!= mindex.end();it++)
			{
				cout<<vrefChrom[it->second[0]]<<"\t"<<vrefStart[it->second[0]]<<"\t"<<vrefEnd[it->second[0]]<<'\t';
				//cout<<it->second.size()<<'\t';
				cout<<returnUniq(vdspr,it->second)<<'\t';
				writeField(it->second,vrefChrom);
				cout<<"\t";
				writeField(it->second,vrefStart);
				cout<<"\t";
				writeField(it->second,vrefEnd);
				cout<<"\t";
				writeField(it->second,vvar);	
				cout<<"\t";
				writeField(it->second,vdspr);
				cout<<"\t";
				writeField(it->second,vstart);
				cout<<'\t';
				writeField(it->second,vend);
				cout<<'\t';
				writeField(it->second,vid);
				cout<<'\t';
				writeField(it->second,vlen);
				cout<<'\t';
				writeField(it->second,vrcov);
				cout<<'\t';
				writeField(it->second,vqcov);
				cout<<'\n';
			}
		
		}
		else
		{
			cout<<str<<endl;
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
map<int,vector<int> > returnCluster(vector<loc> & vl)
{
	map<int,vector<int> > mindex;
	int ovl =0, index =0; //ovlLen calculates overlapping length of variants
	string varType;
	for(unsigned int i=0;i<vl.size();i++)
	{
		if(i == 0)
		{
			index = i;
			//cout<<"index\t"<<index<<"\t"<<i<<endl;
			mindex[index].push_back(i);
		}
		else//first one cannot be compared to anything
		{
			ovl = min(vl[i-1].end,vl[i].end) - max(vl[i-1].start,vl[i].start); //overlap between ith and (i-1)th elements
			if((double(ovl)/double(vl[i].end - vl[i].start) >0.8) && (double(ovl)/double(vl[i-1].end - vl[i-1].start) >0.8) && (vl[i].var == vl[i-1].var) && (double(min(vl[i-1].len,vl[i].len))/double(max(vl[i-1].len,vl[i].len))>0.8))
			{
				//cout<<"index\t"<<index<<"\t"<<i<<endl;
				mindex[index].push_back(i);
			}
			else
			{
				index = i;
				//cout<<"index\t"<<index<<"\t"<<i<<endl;
				mindex[index].push_back(i);
			}
		}
		
	}
	return mindex;
}
/////////////////////////////////////////////////////////////////////
void writeField(vector<int> & vi,vector<string> & vs)
{
	for(unsigned int i=0;i <vi.size();i++)
	{
		cout<<vs[vi[i]];
		if(i != vi.size()-1)
		{
			cout<<';';
		}
	}
}	
/////////////////////////////////////////////////////////////////////
int returnUniq(vector<string> & vs, vector<int> & vi)
{
	int count =0;
	vector<string> v1;
	for(unsigned int i=0;i<vi.size();i++)
	{
		if(find(v1.begin(),v1.end(),vs[vi[i]]) == v1.end())//if the element does not exist
		{
			v1.push_back(vs[vi[i]]);
		}
	}
	count = v1.size();
	return count;
}
		
