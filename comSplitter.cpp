#include<iostream>
#include<fstream>
#include<string>
#include<iomanip>
#include<vector>
#include<cstdlib>
#include<algorithm>

using namespace std;

struct row{
	string fullRow;
	string chrom;
	int start;
	int end;
	bool operator < (const row& tr) const
	{
		return((chrom < tr.chrom) || ((chrom==tr.chrom) && (start < tr.start))\
			||((chrom == tr.chrom) && (start == tr.start) && (end < tr.end)));
	}
	};

vector<string> splitField(string & str, char c);
string joinField(vector<string> & vs, string c);

int main(int argc, char *argv[])
{
	if(argc <2) 
	{
		cerr<<"Usage: comSplitter input.txt"<<endl;
		exit(EXIT_FAILURE);
	}
	ifstream fin;
	fin.open(argv[1]);
	string str;
	vector<string> vs;
	vector<row> master;//non-complex events
	vector<row> com; //complex events
	int st=0, end =0;
	row tempRow;
	while(getline(fin,str))
	{
		vs = splitField(str,'\t');
		tempRow.fullRow = str;
		tempRow.chrom = vs[0];
		tempRow.start = stoi(vs[1]);
		tempRow.end = stoi(vs[2]);
		if(vs[15] == "1") //a complex event
		{
			vs[15] = "2";//change the nomenclature
			tempRow.fullRow = joinField(vs,"\t");
			com.push_back(tempRow);
		}
		if(vs[15] == "0")//not complex
		{
			master.push_back(tempRow);
		}
//cout<<str<<endl;
	}
//cout<<"camehere"<<endl;
		for(unsigned int i=0; i<com.size();i++)
		{
			st = com[i].start;
			end = com[i].end;
			for(unsigned int j=0; j<master.size();j++)
			{
				if(!(master[j].end < (st-5000)) && !(master[j].start > (end+5000)) && (com[i].chrom == master[j].chrom))
				{
					vs = splitField(master[j].fullRow,'\t');
					vs[15] = "1";
					master[j].fullRow = joinField(vs,"\t");
				}
			}
		}
		master.insert(master.end(),com.begin(),com.end());
		sort(master.begin(),master.end());
		for(unsigned int i=0;i<master.size();i++)
		{
			cout<<master[i].fullRow<<endl;
		}
	
	return 0;
}
//////////////////////////////////////
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
			if(tempstr[0] == '\t')
			{
				tempstr = tempstr.substr(1); //remove the preceding delimiter
			}
			pos = pos1+1;
			vs.push_back(tempstr);
			//cout<<tempstr<<endl;
		}
	}
	tempstr = str.substr(pos);
	vs.push_back(tempstr);
	return vs;
}
///////////////////////////////////////////
string joinField(vector<string> & vs, string c)
{
	string str;
	str = vs[0];
	for(unsigned int i=1;i<vs.size();i++)
	{
		str.append(c);
		str.append(vs[i]);
//cout<<str<<endl;
	}
	return str;
}		
