#include<iostream>
#include<fstream>
#include<string>
#include<iomanip>
#include<vector>

using namespace std;

vector<string> splitField(string & str, char c);

int main()
{
	ifstream fin;
	fin.open("dels.nte.txt");
	string str,str1;
	vector<string> vs,vs1;
	int st2=0,end1 =0, lineCt =0,id =1938;
	//bool ovl = 0;//tracks whether there is any overlap
	ofstream fid;
	fid.open("id.txt");
	while(getline(fin,str))
	{
		//id++;
		if(lineCt == 0)
		{
			vs = splitField(str,'\t');
			//st1 = stoi(vs[1]);
			end1 = stoi(vs[2]);
			getline(fin,str1);
			vs1 = splitField(str1,'\t');
			st2 = stoi(vs1[1]);
			//end2 = stoi(vs1[2]);

			if(!(st2>end1))//as the coordinates are sorted;the intervals overlap
			{
				vs.push_back("1");
				vs1.push_back("1");
			}
			else
			{
				vs.push_back("0");
				vs1.push_back("0");
			}
		}
		if(lineCt >0)
		{
			vs1 = splitField(str,'\t');
			st2 = stoi(vs1[1]);
			//end2 = stoi(vs1[2]);
			if(!(st2>end1))
			{
				vs[vs.size()-1] = "1";
				vs1.push_back("1");
			}
			else
			{
				vs1.push_back("0");
			}
		}
			
		for(unsigned int i=0;i<vs.size();i++)
		{
			if(i != vs.size()-1)
			{
				if(i != 11)
				{ 
					cout<<vs[i]<<"\t";
				}
				if(i == 11)
				{
					cout<<setfill('0')<<setw(10)<<id++<<"\t";
					fid<<setfill('0')<<setw(10)<<id<<"\t"<<vs[i]<<endl;
				}
			}
			
			if( i == vs.size()-1)
			{
				cout<<vs[i];
			}
		}
		cout<<endl;
		vs = vs1;
		//st1 = stoi(vs[1]);
		end1 = stoi(vs[2]);
		lineCt++;
	}
	fin.close();
	for(unsigned int i=0;i<vs.size();i++)
	{
		if(i != vs.size()-1)
		{
			cout<<vs[i]<<"\t";
		}
		if( i == vs.size()-1)
		{
			cout<<vs[i];
		}
	}
	fid.close();
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
